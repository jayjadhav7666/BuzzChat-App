import 'package:flutter/material.dart';

class NewContactTile extends StatelessWidget {
  final String btname;
  final IconData icon;
  final VoidCallback onTap;
  const NewContactTile({
    super.key,
    required this.btname,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).colorScheme.primaryContainer,
        ),
        child: Row(
          children: [
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Icon(icon, size: 25),
            ),
            const SizedBox(width: 20),
            Text(btname, style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}
