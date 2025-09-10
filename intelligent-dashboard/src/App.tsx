import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import Dashboard from './components/Dashboard';
import QueryPanel from './components/QueryPanel';
import ResourceMonitor from './components/ResourceMonitor';
import ApiStatus from './components/ApiStatus';
import './styles/globals.css';

const App = () => {
    return (
        <Router>
            <div>
                <Routes>
                    <Route path="/" element={<Dashboard />} />
                    <Route path="/query" element={<QueryPanel />} />
                    <Route path="/monitor" element={<ResourceMonitor />} />
                    <Route path="/api-status" element={<ApiStatus />} />
                </Routes>
            </div>
        </Router>
    );
};

export default App;