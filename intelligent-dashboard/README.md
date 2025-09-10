# Intelligent Dashboard

## Overview
The Intelligent Dashboard is a web application that integrates with Azure Function Apps to query resources and monitor APIs. It provides a dynamic interface for users to interact with Azure resources and receive real-time updates on API statuses.

## Project Structure
```
intelligent-dashboard
├── src
│   ├── components
│   ├── services
│   ├── hooks
│   ├── types
│   ├── utils
│   ├── styles
│   ├── App.tsx
│   └── index.tsx
├── azure-functions
│   ├── ResourceQuery
│   ├── ApiMonitor
│   ├── host.json
│   ├── local.settings.json
│   └── package.json
├── public
│   └── index.html
├── package.json
├── tsconfig.json
├── .env.example
└── README.md
```

## Features
- **Dashboard Interface**: Displays various metrics and information retrieved from Azure resources.
- **Query Panel**: Allows users to input queries for Azure resources and sends them to the query service.
- **Resource Monitor**: Visualizes the status and metrics of Azure resources, updating dynamically.
- **API Status**: Displays the status of various APIs with real-time updates.

## Setup Instructions
1. Clone the repository:
   ```
   git clone <repository-url>
   cd intelligent-dashboard
   ```

2. Install dependencies for the React application:
   ```
   npm install
   ```

3. Install dependencies for the Azure Functions:
   ```
   cd azure-functions
   npm install
   ```

4. Configure environment variables by copying `.env.example` to `.env` and updating the values as needed.

5. Start the React application:
   ```
   npm start
   ```

6. Run the Azure Functions locally:
   ```
   cd azure-functions
   func start
   ```

## Usage
- Access the dashboard through your web browser at `http://localhost:3000`.
- Use the Query Panel to input queries and view results dynamically.
- Monitor API statuses and Azure resources in real-time.

## Contributing
Contributions are welcome! Please submit a pull request or open an issue for any enhancements or bug fixes.

## License
This project is licensed under the MIT License.