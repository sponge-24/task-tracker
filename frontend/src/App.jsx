import { useState, useEffect } from 'react';
import { getTasks, createTask, updateTask, deleteTask } from './api';
import './App.css';

function App() {
    const [tasks, setTasks] = useState([]);
    const [newTask, setNewTask] = useState('');

    useEffect(() => {
        fetchTasks();
    }, []);

    const fetchTasks = async () => {
        const response = await getTasks();
        setTasks(response.data);
    };

    const handleCreateTask = async () => {
        if (newTask.trim()) {
            await createTask({ title: newTask, completed: false });
            setNewTask('');
            fetchTasks();
        }
    };

    const handleUpdateTask = async (id, completed) => {
        const task = tasks.find(t => t.id === id);
        await updateTask(id, { ...task, completed });
        fetchTasks();
    };

    const handleDeleteTask = async (id) => {
        await deleteTask(id);
        fetchTasks();
    };

    return (
        <div className="App">
            <h1>Task Tracker</h1>
            <div className="task-input">
                <input
                    type="text"
                    value={newTask}
                    onChange={(e) => setNewTask(e.target.value)}
                    placeholder="Enter a new task"
                />
                <button onClick={handleCreateTask}>Add Task</button>
            </div>
            <ul>
                {tasks.map(task => (
                    <li key={task.id} className={task.completed ? 'completed' : ''}>
                        <span onClick={() => handleUpdateTask(task.id, !task.completed)}>
                            {task.title}
                        </span>
                        <button onClick={() => handleDeleteTask(task.id)}>Complete</button>
                    </li>
                ))}
            </ul>
        </div>
    );
}

export default App;
