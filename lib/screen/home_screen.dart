import 'package:flutter/material.dart';
import 'package:todo_list/entity/create_todo.dart';
import 'package:todo_list/services/todo_service.dart';

import '../model/todo.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class MyTodoList extends ValueNotifier<List<Todo>> {
  MyTodoList() : super([]);
  final TodoService _todoService = TodoService();

  void getAllTodo() async {
    value = await _todoService.getAllTodo();
    notifyListeners();
  }

  void removeTodo(int id) async {
    _todoService.remove(id);
    value = await _todoService.getAllTodo();
    notifyListeners();
  }

  void addTodo(CreateTodo createTodo) async {
    _todoService.add(createTodo);
    value = await _todoService.getAllTodo();
    notifyListeners();
  }

  void updateTodo(Todo updateTodo) async {
    _todoService.update(updateTodo);
    value = await _todoService.getAllTodo();
    notifyListeners();
  }
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final _textEditingController = TextEditingController();
  late TabController _tabController;
  final MyTodoList myTodoList = MyTodoList();

  @override
  void initState() {
    super.initState();
    myTodoList.getAllTodo();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    myTodoList.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ValueListenableBuilder(
                valueListenable: myTodoList,
                builder: (context, todoList, builder) {
                  return Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'You have ${todoList.where((element) => element.isCompleted == 0).length} incomplete tasks',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 18.0,
                          ),
                        ),
                        const Icon(Icons.sunny),
                      ],
                    ),
                  );
                }),
            ValueListenableBuilder(
                valueListenable: myTodoList,
                builder: (context, todoList, builder) {
                  return TabBar(
                    controller: _tabController,
                    labelColor: Colors.deepPurple,
                    tabs: [
                      Tab(
                          text:
                              'Incomplete(${todoList.where((element) => element.isCompleted == 0).length})'),
                      Tab(
                        text:
                            "Completed(${todoList.where((element) => element.isCompleted == 1).length})",
                      ),
                      Tab(text: 'All (${myTodoList.value.length})'),
                    ],
                  );
                }),
            // The input field to add more items
            Expanded(
              child: ValueListenableBuilder<List<Todo>>(
                valueListenable: myTodoList,
                builder: (context, todoList, builder) {
                  if (todoList.isEmpty) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black38),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(5.0),
                            ),
                          ),
                          padding: const EdgeInsets.all(14.0),
                          child: Column(
                            children: const [
                              Icon(Icons.hourglass_empty, size: 48.0),
                              Text(
                                "There is no todo list",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else {
                    return TabBarView(
                      controller: _tabController,
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(
                            vertical: 5.0,
                            horizontal: 8.0,
                          ),
                          child: ListView.separated(
                            itemBuilder: (context, index) {
                              Todo todo = todoList[index];
                              if (todo.isCompleted == 0) {
                                return Dismissible(
                                  onDismissed: (dismissed) {
                                    myTodoList.removeTodo(todo.id);
                                  },
                                  key: ValueKey(todo.id),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black38),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(10.0),
                                      ),
                                    ),
                                    child: ListTile(
                                      leading: InkWell(
                                        onTap: () {
                                          // Invert isCompleted
                                          int invertedTask =
                                              (todo.isCompleted == 0 ? 1 : 0);
                                          myTodoList.updateTodo(
                                            Todo(
                                                id: todo.id,
                                                description: todo.description,
                                                isCompleted: invertedTask),
                                          );
                                        },
                                        child: Icon((todo.isCompleted == 1)
                                            ? Icons.check_circle_outline
                                            : Icons.circle_outlined),
                                      ),
                                      title: Text(
                                        todo.description,
                                        style: TextStyle(
                                          decoration: (todo.isCompleted == 1)
                                              ? TextDecoration.lineThrough
                                              : TextDecoration.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }
                            },
                            itemCount: todoList.length,
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const SizedBox(height: 10.0);
                            },
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                            vertical: 5.0,
                            horizontal: 8.0,
                          ),
                          child: ListView.separated(
                            itemBuilder: (context, index) {
                              Todo todo = todoList[index];
                              if (todo.isCompleted == 1) {
                                return Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black38),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(10.0),
                                    ),
                                  ),
                                  child: ListTile(
                                    leading: InkWell(
                                      onTap: () {
                                        // Invert isCompleted
                                        int invertedTask =
                                            (todo.isCompleted == 0 ? 1 : 0);
                                        myTodoList.updateTodo(
                                          Todo(
                                              id: todo.id,
                                              description: todo.description,
                                              isCompleted: invertedTask),
                                        );
                                      },
                                      child: Icon((todo.isCompleted == 1)
                                          ? Icons.check_circle_outline
                                          : Icons.circle_outlined),
                                    ),
                                    title: Text(
                                      todo.description,
                                      style: TextStyle(
                                        decoration: (todo.isCompleted == 1)
                                            ? TextDecoration.lineThrough
                                            : TextDecoration.none,
                                      ),
                                    ),
                                  ),
                                );
                              }
                            },
                            itemCount: todoList.length,
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const SizedBox(height: 10.0);
                            },
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                            vertical: 5.0,
                            horizontal: 8.0,
                          ),
                          child: ListView.separated(
                            itemBuilder: (context, index) {
                              Todo todo = todoList[index];
                              return Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black38),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                ),
                                child: ListTile(
                                  leading: InkWell(
                                    onTap: () {
                                      // Invert isCompleted
                                      int invertedTask =
                                          (todo.isCompleted == 0 ? 1 : 0);
                                      myTodoList.updateTodo(
                                        Todo(
                                            id: todo.id,
                                            description: todo.description,
                                            isCompleted: invertedTask),
                                      );
                                    },
                                    child: Icon((todo.isCompleted == 1)
                                        ? Icons.check_circle_outline
                                        : Icons.circle_outlined),
                                  ),
                                  title: Text(
                                    todo.description,
                                    style: TextStyle(
                                      decoration: (todo.isCompleted == 1)
                                          ? TextDecoration.lineThrough
                                          : TextDecoration.none,
                                    ),
                                  ),
                                ),
                              );
                            },
                            itemCount: todoList.length,
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const SizedBox(height: 10.0);
                            },
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textEditingController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: 'Create a task',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        filled: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Container(
                    width: 50.0,
                    height: 50.0,
                    decoration: BoxDecoration(
                      color: Colors.deepPurpleAccent,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        myTodoList.addTodo(
                          CreateTodo(
                              description: _textEditingController.text,
                              isCompleted: 0),
                        );
                        _textEditingController.clear();
                      },
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
