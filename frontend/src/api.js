import axios from 'axios';

const apiClient = axios.create({
    baseURL: '/api',
    headers: {
        'Content-Type': 'application/json'
    }
});

export const getTasks = () => apiClient.get('/tasks');
export const createTask = (task) => apiClient.post('/tasks', task);
export const updateTask = (id, task) => apiClient.put(`/tasks/${id}`, task);
export const deleteTask = (id) => apiClient.delete(`/tasks/${id}`);
