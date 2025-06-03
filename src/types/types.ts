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

// Corrected extension of WebSocket
export interface CustomWebSocket extends WebSocket {
  playerId?: string;
  _socket?: {
    remoteAddress?: string;
  };
  // Explicitly define the 'on' method with correct return type
  on(event: string, listener: (...args: any[]) => void): this;
}


export interface LoginRequest {
  email: string;
  password: string;
}

export interface RegisterRequest {
  name: string;
  email: string;
  password: string;
}

export interface AuthResponse {
  id: string;
  name: string;
  token: string;
}