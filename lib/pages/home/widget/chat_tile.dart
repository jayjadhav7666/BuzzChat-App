import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ChatTile extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String lastChat;
  final String lastTime;
  final int unreadCount;
  const ChatTile({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.lastChat,
    required this.lastTime,
    required this.unreadCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 60,
            width: 60,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(shape: BoxShape.circle),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              width: 70,
              placeholder:
                  (context, url) => Center(
                    child: SizedBox(
                      height: 35,
                      width: 35,
                      child: CircularProgressIndicator(),
                    ),
                  ),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),

          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: lastTime.isEmpty ? double.infinity : 220,
                  child: Text(
                    name,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge!.copyWith(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  lastChat,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),

          Column(
            children: [
              Text(lastTime, style: Theme.of(context).textTheme.labelMedium),
              const SizedBox(height: 5),
              unreadCount != 0
                  ? Container(
                    width: 25,
                    height: 25,
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Theme.of(context).colorScheme.surface,
                    ),
                    child: Center(
                      child: Text(
                        unreadCount.toString(),
                        // style: Theme.of(
                        //   context,
                        // ).textTheme.labelMedium?.copyWith(
                        //   color: Theme.of(context).colorScheme.surface,
                        // ),
                      ),
                    ),
                  )
                  : SizedBox.shrink(),
            ],
          ),
        ],
      ),
    );
  }
}
