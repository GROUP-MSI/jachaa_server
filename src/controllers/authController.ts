import { Request, Response } from "express";
import { PrismaClient } from "../generated/prisma";
import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";

const prisma = new PrismaClient();

export class AuthController {
  static async register(req: Request, res: Response): Promise<void> {
    try {
      const { name, email, password } = req.body;

      // Verificar si el usuario ya existe
      const existingUser = await prisma.user.findUnique({ where: { email } });
      if (existingUser) {
        res.status(400).json({ message: "El usuario ya existe" });
        return;
      }

      // Encriptar contraseña
      const hashedPassword = await bcrypt.hash(password, 10);

      // Crear usuario
      const user = await prisma.user.create({
        data: {
          name,
          email,
          password: hashedPassword,
        },
      });

      // Generar token
      const token = jwt.sign(
        { userId: user.id },
        process.env.JWT_SECRET || "default_secret",
        { expiresIn: "24h" }
      );

      res.status(201).json({
        id: user.id,
        name: user.name,
        token,
      });
    } catch (error) {
      res.status(500).json({ message: "Error al registrar usuario" });
    }
  }

  static async login(req: Request, res: Response): Promise<void> {
    try {
      const { email, password } = req.body;

      // Buscar usuario
      const user = await prisma.user.findUnique({ where: { email } });
      if (!user) {
        res.status(400).json({ message: "Credenciales inválidas" });
        return;
      }

      // Verificar contraseña
      const validPassword = await bcrypt.compare(password, user.password);
      if (!validPassword) {
        res.status(400).json({ message: "Credenciales inválidas" });
        return;
      }

      // Generar token
      const token = jwt.sign(
        { userId: user.id },
        process.env.JWT_SECRET || "default_secret",
        { expiresIn: "24h" }
      );

      res.json({
        id: user.id,
        name: user.name,
        token,
      });
    } catch (error) {
      res.status(500).json({ message: "Error al iniciar sesión" });
    }
  }
}
