import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/pages/add.dart';
import 'package:todo_app/pages/complete.dart';
import 'package:todo_app/providers/todo_provider.dart';

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Todo> todos = ref.watch(todoProvider);

    List<Todo> activeTodos =
        todos.where((todo) => todo.complete == false).toList();
    List<Todo> completedTodos =
        todos.where((todo) => todo.complete == true).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo App"),
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: activeTodos.length + 1,
          itemBuilder: (context, index) {
            // if (activeTodos.isEmpty) {
            //   return const Padding(
            //     padding: EdgeInsets.only(top : 300),
            //     child: Center(
            //       child: Text('Add a Todo using a button below'),
            //     ),
            //   );
            // } else 
            if (index == activeTodos.length) {
              if (completedTodos.isEmpty) {
                return Container();
              } else {
                return Center(
                  child: TextButton(
                    child: const Text("Completed Todos", style: TextStyle(color: Colors.black),),
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const CompletedTodo(),
                      ),
                    ),
                  ),
                );
              }
            } else {
              return Slidable(
                startActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (context) => ref
                          .watch(todoProvider.notifier)
                          .deleteTodo(activeTodos[index].todoId),
                      icon: Icons.delete,
                      backgroundColor: Colors.red,
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                    )
                  ],
                ),
                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (context) => ref
                          .watch(todoProvider.notifier)
                          .completeTodo(activeTodos[index].todoId),
                      icon: Icons.check,
                      backgroundColor: Colors.green,
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                    )
                  ],
                ),
                child: Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: ListTile(
                    title: Text(activeTodos[index].content),
                  ),
                ),
              );
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AddTodo(),
          ),
        ),
        tooltip: 'Increment',
        backgroundColor: Colors.black,
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
