import 'package:flutter/material.dart';

class LeaderboardPlaceholder extends StatelessWidget {
  final int count;
  final VoidCallback? onInvite;
  final VoidCallback? onHowToEarn;

  const LeaderboardPlaceholder({
    this.count = 0,
    this.onInvite,
    this.onHowToEarn,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = theme.colorScheme.primary;
    final surface = theme.colorScheme.primaryContainer;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Card(
        color: surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Top row: three placeholder avatars with ranks
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (i) {
                  final rank = i + 1;
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      children: [
                        Container(
                          width: i == 1
                              ? 72
                              : 56, // winner slightly larger in center
                          height: i == 1 ? 72 : 56,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white24),
                            color: Colors.grey.shade800,
                          ),
                          child: Center(
                            child: Text(
                              rank.toString(),
                              style: TextStyle(
                                color: Colors.white54,
                                fontWeight: FontWeight.bold,
                                fontSize: i == 1 ? 20 : 16,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        SizedBox(
                          width: 76,
                          child: Text(
                            rank == 1 ? '—' : (rank == 2 ? '—' : '—'),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white38,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),

              const SizedBox(height: 12),

              // Main text
              Text(
                count == 0
                    ? 'No top spenders yet'
                    : 'Not enough data to show the leaderboard',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Be the first to earn points at your favourite venues. Invite friends or make purchases to climb the leaderboard.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),

              const SizedBox(height: 14),

              // CTAs
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accent,
                      foregroundColor: Colors.black,
                    ),
                    onPressed: onInvite,
                    icon: const Icon(Icons.person_add, color: Colors.black),
                    label: const Text(
                      'Invite',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.white12),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: onHowToEarn,
                    child: const Text('How to earn'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
