export function formatTransactionData(transactions) {
    return transactions.map(transaction => ({
        id: transaction.id,
        amount: transaction.amount.toFixed(2),
        date: new Date(transaction.date).toLocaleDateString(),
        description: transaction.description || 'No description provided',
    }));
}

export function formatAccountData(accounts) {
    return accounts.map(account => ({
        id: account.id,
        balance: account.balance.toFixed(2),
        accountType: account.type,
        createdDate: new Date(account.createdDate).toLocaleDateString(),
    }));
}

export function formatApiStatusData(apiStatus) {
    return apiStatus.map(api => ({
        name: api.name,
        status: api.isHealthy ? 'Healthy' : 'Unhealthy',
        lastChecked: new Date(api.lastChecked).toLocaleString(),
    }));
}