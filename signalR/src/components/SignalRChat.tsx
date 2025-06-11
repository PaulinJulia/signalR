import { useEffect, useRef, useState } from "react";
import SignalRService from "../services/SignalRService";

const SignalRChat = () => {
  const [user, setUser] = useState<string>("");
  const [message, setInputMessage] = useState<string>("");
  const [messages, setMessages] = useState<{ user: string; message: string }[]>(
    []
  );
  const messagesEndRef = useRef<HTMLDivElement | null>(null);

  useEffect(() => {
    const handleMessage = (user: string, message: string) => {
      setMessages((prev) => [...prev, { user, message }]);
    };
    const unsubscribe = SignalRService.onMessage(handleMessage);
    return () => unsubscribe();
  }, []);

  useEffect(() => {
    messagesEndRef.current?.scrollIntoView({ behavior: "smooth" });
  }, [messages]);

  const handleSendMessage = async () => {
    SignalRService.sendMessage(user, message);
    setInputMessage("");
  };

  return (
    <div
      style={{
        display: "flex",
        flexDirection: "column",
        alignItems: "center",
      }}
    >
      <div
        style={{
          marginTop: 10,
          height: "100px",
          width: "200px",
          overflowY: "auto",
          overflowX: "hidden",
          wordBreak: "break-word",
          padding: "8px",
          scrollbarWidth: "none",
          msOverflowStyle: "none",
          borderRadius: "4px",
        }}
      >
        <h3>Messages:</h3>
        {messages.map((m, index) => (
          <div key={index}>
            <b>{m.user}: </b> {m.message}
          </div>
        ))}
        <div ref={messagesEndRef} />
      </div>
      <br />
      <input
        id="chat-username"
        type="text"
        placeholder="Name"
        value={user}
        onChange={(e) => setUser(e.target.value)}
      />
      <br />
      <textarea
        id="chat-message"
        placeholder="Message"
        value={message}
        onChange={(e) => setInputMessage(e.target.value)}
        rows={3}
        cols={30}
        onKeyDown={(e) => {
          if (e.key === "Enter" && !e.shiftKey) {
            e.preventDefault();
            handleSendMessage();
          }
        }}
      />
      <br />
      <button onClick={handleSendMessage}>Send</button>
    </div>
  );
};

export default SignalRChat;
