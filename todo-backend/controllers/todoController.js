let todos = [];
let idCounter = 1;

exports.getTodos = (req, res) => {
    res.json(todos);
};

exports.createTodo = (req, res) => {
    const todo = {
        id: idCounter++,
        title: req.body.title,
        completed: false,
    };
    todos.push(todo);
    res.json(todo);
};

exports.updateTodo = (req, res) => {
    const id = parseInt(req.params.id);
    const todo = todos.find(t => t.id === id);

    if (!todo) return res.status(404).send();

    todo.title = req.body.title ?? todo.title;
    todo.completed = req.body.completed ?? todo.completed;

    res.json(todo);
};

exports.deleteTodo = (req, res) => {
    const id = parseInt(req.params.id);
    todos = todos.filter(t => t.id !== id);
    res.sendStatus(204);
};