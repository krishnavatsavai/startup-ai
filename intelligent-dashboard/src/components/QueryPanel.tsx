import React, { useState } from 'react';
import { queryService } from '../services/queryService';

const QueryPanel: React.FC = () => {
    const [query, setQuery] = useState('');
    const [results, setResults] = useState<any[]>([]);
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState<string | null>(null);

    const handleQueryChange = (event: React.ChangeEvent<HTMLInputElement>) => {
        setQuery(event.target.value);
    };

    const handleSubmit = async (event: React.FormEvent<HTMLFormElement>) => {
        event.preventDefault();
        setLoading(true);
        setError(null);

        try {
            const response = await queryService.executeQuery(query);
            setResults(response);
        } catch (err) {
            setError('Error fetching results. Please try again.');
        } finally {
            setLoading(false);
        }
    };

    return (
        <div className="query-panel">
            <form onSubmit={handleSubmit}>
                <input
                    type="text"
                    value={query}
                    onChange={handleQueryChange}
                    placeholder="Enter your query"
                    required
                />
                <button type="submit" disabled={loading}>
                    {loading ? 'Loading...' : 'Submit'}
                </button>
            </form>
            {error && <div className="error">{error}</div>}
            <div className="results">
                {results.map((result, index) => (
                    <div key={index}>{JSON.stringify(result)}</div>
                ))}
            </div>
        </div>
    );
};

export default QueryPanel;