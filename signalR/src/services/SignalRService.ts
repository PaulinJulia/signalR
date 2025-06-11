import * as signalR from "@microsoft/signalr";

type MessageHandler = (user: string, message: string) => void;

const baseUrl = import.meta.env.PROD
  ? "https://signalrchat-kgrw.onrender.com"
  : "http://localhost:5263";

class SignalRService {
  private connection: signalR.HubConnection;
  private messageHandlers: MessageHandler[] = [];

  constructor() {
    this.connection = new signalR.HubConnectionBuilder()
      .withUrl("https://signalrchat-kgrw.onrender.com/chatHub")
      .withAutomaticReconnect()
      .configureLogging(signalR.LogLevel.Information)
      .build();

    this.connection.on("ReceiveMessage", (user: string, message: string) => {
      this.messageHandlers.forEach((handler) => handler(user, message));
    });

    this.connection
      .start()
      .then(() => console.log("SignalR Connected"))
      .catch((err) => console.error("SignalR Connection Error: ", err));
  }

  public onMessage(handler: MessageHandler): () => void {
    this.messageHandlers.push(handler);
    return () => {
      this.messageHandlers = this.messageHandlers.filter((h) => h !== handler);
    };
  }

  public sendMessage(user: string, message: string): void {
    this.connection
      .invoke("SendMessage", user, message)
      .catch((err) => console.error("Send Message Error: ", err));
  }
}

export default new SignalRService();
