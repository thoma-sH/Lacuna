import 'package:flutter/material.dart';

class PostCapturePage extends StatelessWidget {
  const PostCapturePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Post')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.black12,
            ),
            child: const Center(
              child: Icon(Icons.camera_alt_outlined, size: 64),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Camera-only capture (photo/video max 60s).'),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.videocam_outlined),
            label: const Text('Open camera'),
          ),
          const SizedBox(height: 12),
          TextFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Text caption (optional)',
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 12),
          FilledButton.tonalIcon(
            onPressed: () {},
            icon: const Icon(Icons.mic_none),
            label: const Text('Record audio caption'),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: 'Vibing',
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Post to blob',
            ),
            items: const [
              DropdownMenuItem(value: 'Vibing', child: Text('Vibing')),
              DropdownMenuItem(value: 'Sad', child: Text('Sad')),
              DropdownMenuItem(value: 'Beach', child: Text('Beach')),
            ],
            onChanged: (_) {},
          ),
          const SizedBox(height: 12),
          FilledButton.tonalIcon(
            onPressed: () {},
            icon: const Icon(Icons.location_on_outlined),
            label: const Text('Tag location'),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () {},
            child: const Text('Post'),
          ),
        ],
      ),
    );
  }
}
