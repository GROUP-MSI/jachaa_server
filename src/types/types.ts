import { WebSocket } from 'ws';

export interface Player {
  id: string;
  username: string;
  position: string;
  lastActivity: Date;
}

export interface Message {
  type: 'join' | 'move' | 'chat' | 'leave' | 'error' | 'init';
  data: any;
}

export interface ActivityLog {
  timestamp: Date;
  type: string;
  details: string;
  playerId?: string;
}

// Extensión correcta de WebSocket
export interface CustomWebSocket extends WebSocket {
  playerId?: string;
  _socket?: {
    remoteAddress?: string;
  };
  on: WebSocket['on']; // Hereda el método 'on' de WebSocket
}