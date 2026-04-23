const express = require("express");
const cors = require("cors");

const app = express();
app.use(cors());
app.use(express.json());

let todos = [];
let idCounter = 1;

// CREATE
app.post("/todos", (req, res) => {
    const todo = {
        id: idCounter++,
        title: req.body.title,
        completed: false,
    };
    todos.push(todo);
    res.json(todo);
});

// READ
app.get("/todos", (req, res) => {
    res.json(todos);
});

// UPDATE
app.put("/todos/:id", (req, res) => {
    const id = parseInt(req.params.id);
    const todo = todos.find(t => t.id === id);

    if (!todo) return res.status(404).send("Not found");

    todo.title = req.body.title ?? todo.title;
    todo.completed = req.body.completed ?? todo.completed;

    res.json(todo);
});

// DELETE
app.delete("/todos/:id", (req, res) => {
    const id = parseInt(req.params.id);
    todos = todos.filter(t => t.id !== id);
    res.sendStatus(204);
});

app.listen(3000, () => {
    console.log("Server running on http://localhost:3000");
});