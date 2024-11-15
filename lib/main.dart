import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DockPage(),
    );
  }
}

class DockPage extends StatefulWidget {
  @override
  _DockPageState createState() => _DockPageState();
}

class _DockPageState extends State<DockPage> {
  List<DockItemData> dockItems = [
    DockItemData(icon: Icons.home, label: 'Home'),
    DockItemData(icon: Icons.search, label: 'Search'),
    DockItemData(icon: Icons.settings, label: 'Settings'),
    DockItemData(icon: Icons.notifications, label: 'Notifications'),
    DockItemData(icon: Icons.person, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Container(
                height: 100,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: dockItems
                      .asMap()
                      .map((index, item) => MapEntry(
                          index,
                          _buildDraggableDockItem(
                              item, index))) // Build draggable item
                      .values
                      .toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDraggableDockItem(DockItemData item, int index) {
    return Draggable<DockItemData>(
      data: item,
      feedback: _buildDockItem(
          item, Colors.blue[700], 1.2), // Feedback shown while dragging
      childWhenDragging:
          Opacity(opacity: 0.5, child: _buildDockItem(item, Colors.blue)),
      onDragStarted: () {
        setState(() {
          // Optionally set a flag to show that dragging has started.
        });
      },
      onDraggableCanceled: (velocity, offset) {
        setState(() {
          // Reset the flag or handle any cleanup when the drag is cancelled.
        });
      },
      onDragEnd: (details) {
        setState(() {
          // Optionally handle any additional logic when drag ends.
        });
      },
      onDragCompleted: () {}, // Drag completed without cancellation
      child: DragTarget<DockItemData>(
        builder: (context, candidateData, rejectedData) {
          return AnimatedSwitcher(
            duration: Duration(milliseconds: 800),
            child: _buildDockItem(item, Colors.blue),
          );
        },
        onWillAccept: (incomingItem) {
          if (incomingItem != null && incomingItem != item) {
            setState(() {
              _reorderItems(incomingItem, item);
            });
            return true;
          }
          return false;
        },
      ),
    );
  }

  void _reorderItems(DockItemData draggedItem, DockItemData targetItem) {
    final draggedIndex = dockItems.indexOf(draggedItem);
    final targetIndex = dockItems.indexOf(targetItem);

    if (draggedIndex != -1 && targetIndex != -1) {
      setState(() {
        dockItems.removeAt(draggedIndex);
        dockItems.insert(targetIndex, draggedItem);
      });
    }
  }

  Widget _buildDockItem(DockItemData item, Color? color, [double scale = 1.0]) {
    return Transform.scale(
      scale: scale,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          color: color ?? Colors.blue,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Icon(item.icon, color: Colors.white, size: 30),
      ),
    );
  }
}

class DockItemData {
  final IconData icon;
  final String label;

  DockItemData({required this.icon, required this.label});
}
