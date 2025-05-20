import express from 'express';
import { WSServer } from './server/wsServer';
import cors from 'cors';

const HTTP_PORT = 3000;
const WS_PORT = 8080;

// Crear instancia del servidor WebSocket
const wsServer = new WSServer(WS_PORT);

// Configurar servidor Express para monitoreo
const app = express();
app.use(cors());
app.use(express.json());

// Endpoint para obtener logs
app.get('/api/activity', (req, res) => {
  res.json({
    success: true,
    data: wsServer.getActivityLog()
  });
});

// Endpoint para obtener jugadores conectados
app.get('/api/players', (req, res) => {
  res.json({
    success: true,
    count: wsServer.getPlayerCount(),
    players: wsServer.getPlayers()
  });
});

// Iniciar servidor HTTP
app.listen(HTTP_PORT, () => {
  console.log(`🟢 Servidor de monitoreo en http://localhost:${HTTP_PORT}`);
});