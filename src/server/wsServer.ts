import { WebSocketServer, WebSocket } from 'ws';
import { Player, Message, ActivityLog, CustomWebSocket } from '../types/types';

export class WSServer {
  private wss: WebSocketServer
  private players: Map<string, Player> = new Map();
  private activityLog: ActivityLog[] = [];
  private MAX_PLAYERS = 5;

  constructor(port: number) {
    this.wss = new WebSocketServer({ port });
    console.log(`🟢 Servidor WebSocket iniciado en el puerto ${port}`);

    this.wss.on('connection', (ws: CustomWebSocket) => {
      const clientIp = ws._socket?.remoteAddress || 'IP desconocida';
      this.logActivity('connection', `Nueva conexión desde ${clientIp}`);

      ws.on('message', (data: string) => {
        this.logActivity('message', `Datos recibidos: ${data}`, undefined, 'system');
        this.handleMessage(ws, data);
      });

      ws.on('close', () => {
        this.logActivity('disconnection', 'Cliente desconectado', undefined, 'system');
        this.handleDisconnect(ws);
      });

      ws.on('error', (error: Error) => {
        this.logActivity('error', `Error en conexión: ${error.message}`, undefined, 'system');
      });
    });
  }

  private handleMessage(ws: CustomWebSocket, data: string) {
    try {
      const message = this.parseMessage(data);
      this.logActivity('message', `Procesando mensaje tipo: ${message.type}`);

      switch (message.type) {
        case 'join':
          this.handleJoin(ws, message.data);
          break;
        case 'move':
          this.handleMove(ws, message.data);
          break;
        case 'chat':
          this.handleChat(ws, message.data);
          break;
        default:
          this.logActivity('warning', `Tipo de mensaje desconocido: ${message.type}`);
      }
    } catch (error) {
      const errorMessage = error instanceof Error ? error.message : 'Error desconocido';
      this.logActivity('error', `Error al procesar mensaje: ${errorMessage}`);
      console.error('❌ Error procesando mensaje:', errorMessage);
    }
  }

  private parseMessage(data: string): Message {
    const message = JSON.parse(data);
    
    if (!message.type || !message.data) {
      throw new Error('Mensaje con formato inválido');
    }
    
    return message as Message;
  }

  private handleJoin(ws: CustomWebSocket, username: string) {
    this.logActivity('join_attempt', `Intento de unión: ${username}`);

    if (this.players.size >= this.MAX_PLAYERS) {
      const errorMsg = 'La sala está llena (máximo 5 usuarios)';
      ws.send(JSON.stringify({
        type: 'error',
        data: errorMsg
      }));
      this.logActivity('join_rejected', errorMsg);
      ws.close();
      return;
    }

    const player: Player = {
      id: Math.random().toString(36).substring(7),
      username,
      position: '0,0,0',
      lastActivity: new Date()
    };

    ws.playerId = player.id;
    this.players.set(player.id, player);

    ws.send(JSON.stringify({
      type: 'init',
      data: {
        you: player,
        others: Array.from(this.players.values()).filter(p => p.id !== player.id)
      }
    }));

    this.broadcast({
      type: 'join',
      data: player
    }, ws);

    this.logActivity('join_success', `Usuario ${username} (${player.id}) se unió. Jugadores: ${this.players.size}/${this.MAX_PLAYERS}`, player.id);
  }

  private handleMove(ws: CustomWebSocket, position: string) {
    const player = this.findPlayerBySocket(ws);
    if (!player) return;

    player.position = position;
    player.lastActivity = new Date();

    this.broadcast({
      type: 'move',
      data: { id: player.id, position }
    }, ws);

    this.logActivity('move', `Movimiento a ${position}`, player.id);
  }

  private handleChat(ws: CustomWebSocket, text: string) {
    const player = this.findPlayerBySocket(ws);
    if (!player) return;

    player.lastActivity = new Date();

    this.broadcast({
      type: 'chat',
      data: { from: player.username, text }
    });

    this.logActivity('chat', `Mensaje: "${text}"`, player.id);
  }

  private handleDisconnect(ws: CustomWebSocket) {
    const player = this.findPlayerBySocket(ws);
    if (!player) return;

    this.players.delete(player.id);
    this.broadcast({
      type: 'leave',
      data: { id: player.id }
    });

    this.logActivity('leave', `Usuario desconectado`, player.id);
  }

  private findPlayerBySocket(ws: CustomWebSocket): Player | undefined {
    return ws.playerId ? this.players.get(ws.playerId) : undefined;
  }

  private broadcast(message: Message, exclude?: CustomWebSocket) {
    const data = JSON.stringify(message);
    this.wss.clients.forEach(client => {
      if (client !== exclude && client.readyState === WebSocket.OPEN) {
        client.send(data);
      }
    });
  }

  private logActivity(type: string, details: string, playerId?: string, system: string = '') {
    const logEntry: ActivityLog = {
      timestamp: new Date(),
      type,
      details,
      playerId
    };

    this.activityLog.push(logEntry);
    
    const timestamp = logEntry.timestamp.toISOString();
    const playerInfo = playerId ? `[Jugador: ${playerId}]` : '';
    const systemInfo = system ? `[${system}]` : '';
    
    console.log(`\x1b[90m${timestamp}\x1b[0m \x1b[36m${systemInfo}\x1b[0m \x1b[33m${playerInfo}\x1b[0m ${details}`);
  }

  // Métodos para monitoreo
  public getActivityLog(): ActivityLog[] {
    return this.activityLog;
  }

  public getPlayers(): Player[] {
    return Array.from(this.players.values());
  }

  public getPlayerCount(): number {
    return this.players.size;
  }
}