const express = require('express');
const sqlite3 = require('sqlite3').verbose();
const bodyParser = require('body-parser');
const path = require('path');

const app = express();
const port = process.env.PORT || 3000;

// Configuração do Body-Parser
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// Servir arquivos estáticos (como HTML, CSS, JS)
app.use(express.static(path.join(__dirname, 'public')));

// Configuração do banco de dados SQLite (Persistente)
const db = new sqlite3.Database('./data.db');  // Usando um arquivo persistente

db.serialize(() => {
    db.run("CREATE TABLE IF NOT EXISTS todos (id INTEGER PRIMARY KEY AUTOINCREMENT, task TEXT)");
});

// Rota principal
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'index.html'));
});

// Rota para listar tarefas
app.get('/todos', (req, res) => {
    db.all("SELECT * FROM todos", (err, rows) => {
        if (err) {
            console.error('Erro ao listar tarefas:', err);
            res.status(500).json({ error: err.message });
            return;
        }
        res.json(rows);
    });
});

// Rota para adicionar tarefa
app.post('/todos', (req, res) => {
    const task = req.body.task;
    db.run("INSERT INTO todos (task) VALUES (?)", [task], function(err) {
        if (err) {
            console.error('Erro ao adicionar tarefa:', err);
            res.status(500).json({ error: err.message });
            return;
        }
        res.json({ id: this.lastID, task });
    });
});

// Rota para excluir tarefa
app.delete('/todos/:id', (req, res) => {
    const id = req.params.id;
    db.run("DELETE FROM todos WHERE id = ?", [id], function(err) {
        if (err) {
            console.error('Erro ao excluir tarefa:', err);
            res.status(500).json({ error: err.message });
            return;
        }
        res.json({ deleted: this.changes > 0 });
    });
});

// Endpoint de verificação de saúde
app.get('/healthcheck', (req, res) => {
    res.status(200).send('OK');
});

// Iniciar o servidor
app.listen(port, () => {
    console.log(`Server is running on http://localhost:${port}`);
});