#  Real-Time Messaging with SignalR & .NET

The idea behind this SignalR project is to explore real-time communication in a full-stack environment and create a simple chat application where messages are updated instantly. Without the need to refresh the page. The application demonstrates how SignalR can be used to enhance the user experience with fast and efficient data communication between client and server.

Users can access the site and join an active chat, send messages that are instantly visible to other users, and experience how real-time updates work in practice. The backend is built with .NET and SignalR. The frontend is developed using React and Vite. The project is containerized with Docker to enable easy deployment to platforms like Render or in a Kubernetes environment.

The application also showcases how clients automatically reconnect after disconnection, and how SignalR acts as an intelligent middleware that selects the best available communication protocol depending on browser support—preferably WebSockets.


## Tech Stack
Frontend: React + Vite  
Backend: ASP.NET Core 8 + SignalR  
Real-Time Communication: SignalR with WebSockets  
Containerization: Docker (multi-stage build)  
Deployment: Render

## Screenshot

![Chat](/signalR/src/assets/chat.png "Chat")

## How to install

node.js - https://nodejs.org/en/download  
npm - https://www.npmjs.com/  
dotnet SDK - https://dotnet.microsoft.com/download

```
git clone https://github.com/PaulinJulia/signalR
cd signalR


Backend:
cd SignalR-server
dotnet run

Frontend:
cd signalR
npm install
npm run dev

```

## About

This project is part of my thesis work exploring how SignalR works in containerized environments like Docker and Kubernetes. It has helped me understand the benefits and challenges of real-time solutions and how to build and scale them effectively.

