package network

import (
	"context"
	"fmt"
	"github.com/libp2p/go-libp2p"
	"github.com/libp2p/go-libp2p/core/host"
	"github.com/libp2p/go-libp2p/core/network"
	"github.com/libp2p/go-libp2p/core/peer"
	"encoding/json"
	"log"
	"os"
	"io/ioutil"
	"github.com/libp2p/go-libp2p/core/crypto"
	"runtime/debug"
)

const ProtocolID = "/blockchain/1.0.0"

// P2PNode represents a minimal libp2p node
 type P2PNode struct {
	Host host.Host
	HandleIncomingMessage func(msg NetworkMessage) // Function field for message handling
	// Callbacks for integration
	OnBlockReceived func(block BlockMessage)
	OnTransactionReceived func(tx TransactionMessage)
	OnValidatorRegistrationReceived func(reg ValidatorRegistrationMessage) // New callback
}

// loadOrCreatePrivKey loads a private key from file or generates and saves a new one
func loadOrCreatePrivKey(path string) (crypto.PrivKey, error) {
	if _, err := os.Stat(path); err == nil {
		// File exists, load it
		data, err := ioutil.ReadFile(path)
		if err != nil {
			return nil, err
		}
		privKey, err := crypto.UnmarshalPrivateKey(data)
		if err != nil {
			return nil, err
		}
		return privKey, nil
	}
	// File does not exist, generate new key
	privKey, _, err := crypto.GenerateKeyPair(crypto.Ed25519, -1)
	if err != nil {
		return nil, err
	}
	data, err := crypto.MarshalPrivateKey(privKey)
	if err != nil {
		return nil, err
	}
	if err := ioutil.WriteFile(path, data, 0600); err != nil {
		return nil, err
	}
	return privKey, nil
}

// NewP2PNode creates and starts a new libp2p node listening on the given port, using a persistent private key
func NewP2PNode(ctx context.Context, listenPort int, keyPath ...string) (*P2PNode, error) {
	log.Printf("[DEBUG] NewP2PNode called with listenPort=%d, keyPath=%v", listenPort, keyPath)
	if info, ok := debug.ReadBuildInfo(); ok {
		for _, dep := range info.Deps {
			if dep.Path == "github.com/libp2p/go-libp2p" {
				log.Printf("[DEBUG] Using libp2p version: %s", dep.Version)
			}
		}
	}
	var privKey crypto.PrivKey
	var err error
	if len(keyPath) > 0 && keyPath[0] != "" {
		privKey, err = loadOrCreatePrivKey(keyPath[0])
		if err != nil {
			return nil, err
		}
	}
	opts := []libp2p.Option{
		libp2p.ListenAddrStrings(fmt.Sprintf("/ip4/0.0.0.0/tcp/%d", listenPort)),
	}
	if privKey != nil {
		opts = append(opts, libp2p.Identity(privKey))
	}
	h, err := libp2p.New(opts...)
	if err != nil {
		return nil, err
	}
	fmt.Println("[libp2p] Node ID:", h.ID())
	for _, addr := range h.Addrs() {
		fmt.Println("[libp2p] Listening on:", addr)
	}
	node := &P2PNode{Host: h}
	// Default handler does nothing
	node.HandleIncomingMessage = func(msg NetworkMessage) {}
	return node, nil
}

// RegisterStreamHandler sets up the handler for incoming libp2p streams
func (node *P2PNode) RegisterStreamHandler() {
    node.Host.SetStreamHandler(ProtocolID, func(s network.Stream) {
        remotePeer := s.Conn().RemotePeer()
        log.Printf("[P2P] Stream handler triggered from peer: %s", remotePeer.String())
        defer s.Close()
        var msg NetworkMessage
        decoder := json.NewDecoder(s)
        if err := decoder.Decode(&msg); err != nil {
            log.Printf("[P2P] Error decoding message: %v", err)
            return
        }
        
        // Add peer information to the message
        msg.FromPeer = remotePeer.String()
        log.Printf("[P2P] Received message of type: %s from peer: %s", msg.Type, remotePeer.String())
        
        // Integration: handle block and transaction messages
        switch msg.Type {
        case MsgTypeBlock:
            var blockMsg BlockMessage
            if err := json.Unmarshal(msg.Payload, &blockMsg); err == nil && node.OnBlockReceived != nil {
                node.OnBlockReceived(blockMsg)
            }
        case MsgTypeTransaction:
            var txMsg TransactionMessage
            if err := json.Unmarshal(msg.Payload, &txMsg); err == nil && node.OnTransactionReceived != nil {
                node.OnTransactionReceived(txMsg)
            }
        case MsgTypeValidatorRegistration:
            var regMsg ValidatorRegistrationMessage
            if err := json.Unmarshal(msg.Payload, &regMsg); err == nil && node.OnValidatorRegistrationReceived != nil {
                node.OnValidatorRegistrationReceived(regMsg)
            }
        default:
            node.HandleIncomingMessage(msg)
        }
    })
}

// SendMessage sends a NetworkMessage to the given peer over a new libp2p stream
func (node *P2PNode) SendMessage(ctx context.Context, peerID peer.ID, msg NetworkMessage) error {
    log.Printf("[P2P] Attempting to send message of type: %s to peer: %s", msg.Type, peerID.String())
    s, err := node.Host.NewStream(ctx, peerID, ProtocolID)
    if err != nil {
        log.Printf("[P2P] Error opening stream to peer: %v", err)
        return err
    }
    defer s.Close()
    encoder := json.NewEncoder(s)
    err = encoder.Encode(msg)
    if err != nil {
        log.Printf("[P2P] Error sending message: %v", err)
    } else {
        log.Printf("[P2P] Message sent successfully to peer: %s", peerID.String())
    }
    return err
}

// BroadcastBlock sends a block to all connected peers
func (node *P2PNode) BroadcastBlock(ctx context.Context, blockData []byte) {
	peers := node.Host.Peerstore().Peers()
	for _, peerID := range peers {
		if peerID == node.Host.ID() {
			continue // Don't send to self
		}
		blockMsg := BlockMessage{BlockData: blockData}
		payload, err := json.Marshal(blockMsg)
		if err != nil {
			log.Printf("[P2P] Failed to marshal BlockMessage: %v", err)
			continue
		}
		msg := NetworkMessage{
			Type:    MsgTypeBlock,
			Payload: payload,
		}
		err = node.SendMessage(ctx, peerID, msg)
		if err != nil {
			log.Printf("[P2P] Failed to send block to peer %s: %v", peerID.String(), err)
		} else {
			log.Printf("[P2P] Block sent to peer %s", peerID.String())
		}
	}
} 