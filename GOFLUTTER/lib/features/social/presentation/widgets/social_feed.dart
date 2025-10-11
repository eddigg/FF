import 'package:flutter/material.dart';
import 'package:atlas_blockchain_flutter/shared/widgets/common_widgets.dart' as glass_card;
import 'package:atlas_blockchain_flutter/shared/themes/web_parity_theme.dart';

class SocialFeed extends StatelessWidget {
  const SocialFeed({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data for posts
    final mockPosts = [
      {
        'id': '1',
        'author': 'Alice',
        'time': '2 hours ago',
        'content': 'Just deployed my first smart contract on ATLAS Blockchain! The developer experience is amazing. 🚀',
        'likes': 24,
        'isLiked': false,
        'reposts': 5,
        'comments': [
          {'author': 'Bob', 'content': 'Congrats! How was the deployment process?'},
          {'author': 'Charlie', 'content': 'Awesome work!'},
        ],
      },
      {
        'id': '2',
        'author': 'Bob',
        'time': '5 hours ago',
        'content': 'Working on a new DeFi protocol for the ATLAS ecosystem. Stay tuned for more updates!',
        'likes': 42,
        'isLiked': true,
        'reposts': 12,
        'comments': [
          {'author': 'David', 'content': 'Can\'t wait to see what you build!'},
        ],
      },
      {
        'id': '3',
        'author': 'Charlie',
        'time': '1 day ago',
        'content': 'The ATLAS community is growing fast! Great to see so many developers building on the platform.',
        'likes': 128,
        'isLiked': false,
        'reposts': 32,
        'comments': [],
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('📰 Social Feed', style: WebParityTheme.panelTitleStyle),
        const SizedBox(height: 20),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: mockPosts.length,
          itemBuilder: (context, index) {
            final post = mockPosts[index];
            return _FeedItem(post: post);
          },
        ),
      ],
    );
  }
}

class _FeedItem extends StatefulWidget {
  final Map<String, dynamic> post;

  const _FeedItem({required this.post});

  @override
  State<_FeedItem> createState() => _FeedItemState();
}

class _FeedItemState extends State<_FeedItem> {
  late bool _isLiked;
  late int _likesCount;
  bool _showComments = false;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.post['isLiked'] as bool;
    _likesCount = widget.post['likes'] as int;
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
      _likesCount = _isLiked ? _likesCount + 1 : _likesCount - 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return glass_card.GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF667EEA), Color(0xFF764BA2)]),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    widget.post['author'].substring(0, 1).toUpperCase(),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.post['author'],
                    style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF2D3748)),
                  ),
                  Text(
                    widget.post['time'],
                    style: const TextStyle(fontSize: 14, color: Color(0xFF718096)),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            widget.post['content'],
            style: const TextStyle(fontSize: 16, height: 1.6, color: Color(0xFF4A5568)),
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.only(top: 15),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
            ),
            child: Row(
              children: [
                _ActionButton(
                  icon: Icons.favorite,
                  text: _likesCount.toString(),
                  isLiked: _isLiked,
                  onPressed: _toggleLike,
                ),
                _ActionButton(
                  icon: Icons.comment,
                  text: (widget.post['comments'] as List).length.toString(),
                  onPressed: () => setState(() => _showComments = !_showComments),
                ),
                _ActionButton(
                  icon: Icons.repeat,
                  text: widget.post['reposts'].toString(),
                  onPressed: () {
                    // For stub implementation, we just show a snackbar
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Reposted!')),
                    );
                  },
                ),
                _ActionButton(
                  icon: Icons.report,
                  text: 'Report',
                  onPressed: () {
                    // For stub implementation, we just show a snackbar
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Post reported')),
                    );
                  },
                ),
              ],
            ),
          ),
          if (_showComments)
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if ((widget.post['comments'] as List).isEmpty)
                    const Text(
                      'No comments yet.',
                      style: TextStyle(color: Color(0xFF718096), fontStyle: FontStyle.italic),
                    ),
                  ...(widget.post['comments'] as List).map<Widget>((comment) {
                    return _CommentItem(comment: comment as Map<String, dynamic>);
                  }).toList(),
                  const SizedBox(height: 10),
                  TextField(
                    decoration: WebParityTheme.inputDecoration('Add a comment...'),
                    onSubmitted: (value) {
                      // For stub implementation, we just show a snackbar
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Comment added!')),
                      );
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onPressed;
  final bool isLiked;

  const _ActionButton({
    required this.icon,
    required this.text,
    required this.onPressed,
    this.isLiked = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: isLiked ? Colors.red : const Color(0xFF718096)),
      label: Text(
        text,
        style: TextStyle(color: isLiked ? Colors.red : const Color(0xFF718096)),
      ),
      style: TextButton.styleFrom(padding: EdgeInsets.zero),
    );
  }
}

class _CommentItem extends StatelessWidget {
  final Map<String, dynamic> comment;

  const _CommentItem({required this.comment});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC).withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            comment['author'],
            style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF2D3748)),
          ),
          const SizedBox(height: 4),
          Text(
            comment['content'],
            style: const TextStyle(fontSize: 14, color: Color(0xFF4A5568)),
          ),
        ],
      ),
    );
  }
}