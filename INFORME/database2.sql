-- CreateTable
CREATE TABLE "Permisos" (
    "id" SERIAL NOT NULL,
    "nombre" TEXT NOT NULL,
    "categoria" TEXT NOT NULL,

    CONSTRAINT "Permisos_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "RolesOnPermisos" (
    "id" SERIAL NOT NULL,
    "rolId" INTEGER NOT NULL,
    "permisoId" INTEGER NOT NULL,

    CONSTRAINT "RolesOnPermisos_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Roles" (
    "id" SERIAL NOT NULL,
    "nombre" TEXT NOT NULL,
    "descripcion" TEXT,

    CONSTRAINT "Roles_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "UsuariosOnRoles" (
    "id" SERIAL NOT NULL,
    "usuarioId" INTEGER NOT NULL,
    "rolId" INTEGER NOT NULL,

    CONSTRAINT "UsuariosOnRoles_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Usuarios" (
    "id" SERIAL NOT NULL,
    "nombre" TEXT NOT NULL,
    "apellido" TEXT NOT NULL,
    "correo" TEXT NOT NULL,
    "contrasena" TEXT NOT NULL,
    "estado" BOOLEAN NOT NULL DEFAULT false,
    "creadoEn" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "actualizadoEn" TIMESTAMP(3) NOT NULL,
    "isSuperUser" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "Usuarios_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TipoUsuario" (
    "id" SERIAL NOT NULL,
    "nombre" TEXT NOT NULL,
    "creadoEn" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "actualizadoEn" TIMESTAMP(3) NOT NULL,
    "userId" INTEGER NOT NULL,

    CONSTRAINT "TipoUsuario_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Permisos_nombre_key" ON "Permisos"("nombre");

-- CreateIndex
CREATE UNIQUE INDEX "Roles_nombre_key" ON "Roles"("nombre");

-- CreateIndex
CREATE UNIQUE INDEX "Usuarios_correo_key" ON "Usuarios"("correo");

-- CreateIndex
CREATE UNIQUE INDEX "TipoUsuario_nombre_key" ON "TipoUsuario"("nombre");

-- AddForeignKey
ALTER TABLE "RolesOnPermisos" ADD CONSTRAINT "RolesOnPermisos_rolId_fkey" FOREIGN KEY ("rolId") REFERENCES "Roles"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RolesOnPermisos" ADD CONSTRAINT "RolesOnPermisos_permisoId_fkey" FOREIGN KEY ("permisoId") REFERENCES "Permisos"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UsuariosOnRoles" ADD CONSTRAINT "UsuariosOnRoles_usuarioId_fkey" FOREIGN KEY ("usuarioId") REFERENCES "Usuarios"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UsuariosOnRoles" ADD CONSTRAINT "UsuariosOnRoles_rolId_fkey" FOREIGN KEY ("rolId") REFERENCES "Roles"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TipoUsuario" ADD CONSTRAINT "TipoUsuario_userId_fkey" FOREIGN KEY ("userId") REFERENCES "Usuarios"("id") ON DELETE RESTRICT ON UPDATE CASCADE;



-- new queris

ALTER TABLE "TipoUsuario" DROP CONSTRAINT "TipoUsuario_userId_fkey";

-- AlterTable
ALTER TABLE "TipoUsuario" DROP COLUMN "userId",
ALTER COLUMN "actualizadoEn" SET DEFAULT CURRENT_TIMESTAMP;

-- AlterTable
ALTER TABLE "Usuarios" DROP COLUMN "estado",
ADD COLUMN     "isActive" BOOLEAN NOT NULL DEFAULT true,
ADD COLUMN     "tipoUsuarioId" INTEGER;

-- AddForeignKey
ALTER TABLE "Usuarios" ADD CONSTRAINT "Usuarios_tipoUsuarioId_fkey" FOREIGN KEY ("tipoUsuarioId") REFERENCES "TipoUsuario"("id") ON DELETE SET NULL ON UPDATE CASCADE;



--new querys 2 
-- CreateTable
CREATE TABLE "Transportes" (
    "id" SERIAL NOT NULL,
    "nombre" TEXT NOT NULL,
    "tipoId" INTEGER NOT NULL,
    "tipoUsuarioId" INTEGER NOT NULL,

    CONSTRAINT "Transportes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TipoTransporte" (
    "id" SERIAL NOT NULL,
    "nombre" TEXT NOT NULL,

    CONSTRAINT "TipoTransporte_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Carga" (
    "id" SERIAL NOT NULL,
    "nombre" TEXT NOT NULL,
    "volumen" DOUBLE PRECISION NOT NULL,
    "peso" DOUBLE PRECISION NOT NULL,
    "tipoId" INTEGER NOT NULL,
    "transporteId" INTEGER NOT NULL,

    CONSTRAINT "Carga_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TipoCarga" (
    "id" SERIAL NOT NULL,
    "nombre" TEXT NOT NULL,

    CONSTRAINT "TipoCarga_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Almacen" (
    "id" SERIAL NOT NULL,
    "nombre" TEXT NOT NULL,

    CONSTRAINT "Almacen_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Producto" (
    "id" SERIAL NOT NULL,
    "nombre" TEXT NOT NULL,
    "precio" DOUBLE PRECISION NOT NULL,

    CONSTRAINT "Producto_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Inventario" (
    "id" SERIAL NOT NULL,
    "productoId" INTEGER NOT NULL,
    "almacenId" INTEGER NOT NULL,
    "cantidad" INTEGER NOT NULL,
    "tipoUsuarioId" INTEGER NOT NULL,

    CONSTRAINT "Inventario_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Envios" (
    "id" SERIAL NOT NULL,
    "nombre" TEXT NOT NULL,
    "fechaEnvio" TIMESTAMP(3) NOT NULL,
    "fechaEntrega" TIMESTAMP(3) NOT NULL,
    "estado" TEXT NOT NULL,
    "cargaId" INTEGER NOT NULL,
    "tipoUsuarioId" INTEGER NOT NULL,

    CONSTRAINT "Envios_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "Transportes" ADD CONSTRAINT "Transportes_tipoId_fkey" FOREIGN KEY ("tipoId") REFERENCES "TipoTransporte"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Transportes" ADD CONSTRAINT "Transportes_tipoUsuarioId_fkey" FOREIGN KEY ("tipoUsuarioId") REFERENCES "TipoUsuario"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Carga" ADD CONSTRAINT "Carga_tipoId_fkey" FOREIGN KEY ("tipoId") REFERENCES "TipoCarga"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Carga" ADD CONSTRAINT "Carga_transporteId_fkey" FOREIGN KEY ("transporteId") REFERENCES "Transportes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Inventario" ADD CONSTRAINT "Inventario_productoId_fkey" FOREIGN KEY ("productoId") REFERENCES "Producto"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Inventario" ADD CONSTRAINT "Inventario_almacenId_fkey" FOREIGN KEY ("almacenId") REFERENCES "Almacen"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Inventario" ADD CONSTRAINT "Inventario_tipoUsuarioId_fkey" FOREIGN KEY ("tipoUsuarioId") REFERENCES "TipoUsuario"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Envios" ADD CONSTRAINT "Envios_cargaId_fkey" FOREIGN KEY ("cargaId") REFERENCES "Carga"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Envios" ADD CONSTRAINT "Envios_tipoUsuarioId_fkey" FOREIGN KEY ("tipoUsuarioId") REFERENCES "TipoUsuario"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

--new querys 3

ALTER TABLE "UsuariosOnRoles" DROP CONSTRAINT "UsuariosOnRoles_rolId_fkey";

-- DropForeignKey
ALTER TABLE "UsuariosOnRoles" DROP CONSTRAINT "UsuariosOnRoles_usuarioId_fkey";



--new querys 4 

ALTER TABLE "Envios" DROP CONSTRAINT "Envios_tipoUsuarioId_fkey";

-- DropForeignKey
ALTER TABLE "Inventario" DROP CONSTRAINT "Inventario_tipoUsuarioId_fkey";

-- DropForeignKey
ALTER TABLE "Transportes" DROP CONSTRAINT "Transportes_tipoUsuarioId_fkey";

-- AlterTable
ALTER TABLE "Almacen" ADD COLUMN     "ubicacion" TEXT;

-- AlterTable
ALTER TABLE "Envios" DROP COLUMN "tipoUsuarioId",
ADD COLUMN     "usuarioId" INTEGER NOT NULL;

-- AlterTable
ALTER TABLE "Inventario" DROP COLUMN "tipoUsuarioId",
ADD COLUMN     "estado" TEXT,
ADD COLUMN     "ubicacion" TEXT,
ADD COLUMN     "usuarioId" INTEGER NOT NULL;

-- AlterTable
ALTER TABLE "Transportes" DROP COLUMN "tipoUsuarioId",
ADD COLUMN     "capacidad" DOUBLE PRECISION,
ADD COLUMN     "imagen" TEXT,
ADD COLUMN     "marca" TEXT,
ADD COLUMN     "modelo" TEXT,
ADD COLUMN     "usuarioId" INTEGER NOT NULL;

-- CreateTable
CREATE TABLE "MovimientoInventario" (
    "id" SERIAL NOT NULL,
    "inventarioId" INTEGER NOT NULL,
    "fecha" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "cantidad" INTEGER NOT NULL,
    "tipoMovimiento" TEXT NOT NULL,

    CONSTRAINT "MovimientoInventario_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "RastreoTransporte" (
    "id" SERIAL NOT NULL,
    "transporteId" INTEGER NOT NULL,
    "cargaId" INTEGER NOT NULL,
    "ubicacion" TEXT NOT NULL,
    "fecha" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "RastreoTransporte_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Proformas" (
    "id" SERIAL NOT NULL,
    "nombre" TEXT NOT NULL,
    "fecha" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "tipoId" INTEGER NOT NULL,
    "usuarioId" INTEGER NOT NULL,

    CONSTRAINT "Proformas_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TipoProforma" (
    "id" SERIAL NOT NULL,
    "nombre" TEXT NOT NULL,

    CONSTRAINT "TipoProforma_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "FormularioProforma" (
    "id" SERIAL NOT NULL,
    "proformaId" INTEGER NOT NULL,
    "productoId" INTEGER NOT NULL,
    "cantidad" INTEGER NOT NULL,
    "precio" DOUBLE PRECISION NOT NULL,
    "total" DOUBLE PRECISION NOT NULL DEFAULT 0.0,

    CONSTRAINT "FormularioProforma_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "HistorialSesion" (
    "id" SERIAL NOT NULL,
    "usuarioId" INTEGER NOT NULL,
    "fechaInicio" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "ip" TEXT,
    "navegador" TEXT,

    CONSTRAINT "HistorialSesion_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "Transportes" ADD CONSTRAINT "Transportes_usuarioId_fkey" FOREIGN KEY ("usuarioId") REFERENCES "Usuarios"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Inventario" ADD CONSTRAINT "Inventario_usuarioId_fkey" FOREIGN KEY ("usuarioId") REFERENCES "Usuarios"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MovimientoInventario" ADD CONSTRAINT "MovimientoInventario_inventarioId_fkey" FOREIGN KEY ("inventarioId") REFERENCES "Inventario"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Envios" ADD CONSTRAINT "Envios_usuarioId_fkey" FOREIGN KEY ("usuarioId") REFERENCES "Usuarios"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RastreoTransporte" ADD CONSTRAINT "RastreoTransporte_transporteId_fkey" FOREIGN KEY ("transporteId") REFERENCES "Transportes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RastreoTransporte" ADD CONSTRAINT "RastreoTransporte_cargaId_fkey" FOREIGN KEY ("cargaId") REFERENCES "Carga"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Proformas" ADD CONSTRAINT "Proformas_tipoId_fkey" FOREIGN KEY ("tipoId") REFERENCES "TipoProforma"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Proformas" ADD CONSTRAINT "Proformas_usuarioId_fkey" FOREIGN KEY ("usuarioId") REFERENCES "Usuarios"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "FormularioProforma" ADD CONSTRAINT "FormularioProforma_proformaId_fkey" FOREIGN KEY ("proformaId") REFERENCES "Proformas"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "FormularioProforma" ADD CONSTRAINT "FormularioProforma_productoId_fkey" FOREIGN KEY ("productoId") REFERENCES "Producto"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "HistorialSesion" ADD CONSTRAINT "HistorialSesion_usuarioId_fkey" FOREIGN KEY ("usuarioId") REFERENCES "Usuarios"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- DropTable
DROP TABLE "UsuariosOnRoles";

-- CreateTable
CREATE TABLE "RolesOnTipoUsuario" (
    "id" SERIAL NOT NULL,
    "tipoUsuarioId" INTEGER NOT NULL,
    "rolId" INTEGER NOT NULL,

    CONSTRAINT "RolesOnTipoUsuario_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "RolesOnTipoUsuario" ADD CONSTRAINT "RolesOnTipoUsuario_tipoUsuarioId_fkey" FOREIGN KEY ("tipoUsuarioId") REFERENCES "TipoUsuario"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RolesOnTipoUsuario" ADD CONSTRAINT "RolesOnTipoUsuario_rolId_fkey" FOREIGN KEY ("rolId") REFERENCES "Roles"("id") ON DELETE RESTRICT ON UPDATE CASCADE;


--new querys 5 



-- AlterTable
ALTER TABLE "Carga" ADD COLUMN     "idEstado" INTEGER NOT NULL DEFAULT 1;

-- AlterTable
ALTER TABLE "Envios" ADD COLUMN     "direccionDestino" TEXT NOT NULL,
ADD COLUMN     "direccionOrigen" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "RastreoTransporte" ADD COLUMN     "idEstado" INTEGER NOT NULL DEFAULT 1;

-- AlterTable
ALTER TABLE "Transportes" ADD COLUMN     "idEstado" INTEGER NOT NULL DEFAULT 1;

-- CreateTable
CREATE TABLE "EstadoTransporte" (
    "id" SERIAL NOT NULL,
    "nombre" TEXT NOT NULL,

    CONSTRAINT "EstadoTransporte_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "EstadoCarga" (
    "id" SERIAL NOT NULL,
    "nombre" TEXT NOT NULL,

    CONSTRAINT "EstadoCarga_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "EstadoRastreo" (
    "id" SERIAL NOT NULL,
    "nombre" TEXT NOT NULL,

    CONSTRAINT "EstadoRastreo_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "Transportes" ADD CONSTRAINT "Transportes_idEstado_fkey" FOREIGN KEY ("idEstado") REFERENCES "EstadoTransporte"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Carga" ADD CONSTRAINT "Carga_idEstado_fkey" FOREIGN KEY ("idEstado") REFERENCES "EstadoCarga"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RastreoTransporte" ADD CONSTRAINT "RastreoTransporte_idEstado_fkey" FOREIGN KEY ("idEstado") REFERENCES "EstadoRastreo"("id") ON DELETE RESTRICT ON UPDATE CASCADE;


--new query 6 
-- DropForeignKey
ALTER TABLE "Transportes" DROP CONSTRAINT "Transportes_tipoId_fkey";

-- DropForeignKey
ALTER TABLE "Transportes" DROP CONSTRAINT "Transportes_usuarioId_fkey";

-- AlterTable
ALTER TABLE "Transportes" ALTER COLUMN "tipoId" DROP NOT NULL,
ALTER COLUMN "usuarioId" DROP NOT NULL;

-- AddForeignKey
ALTER TABLE "Transportes" ADD CONSTRAINT "Transportes_tipoId_fkey" FOREIGN KEY ("tipoId") REFERENCES "TipoTransporte"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Transportes" ADD CONSTRAINT "Transportes_usuarioId_fkey" FOREIGN KEY ("usuarioId") REFERENCES "Usuarios"("id") ON DELETE SET NULL ON UPDATE CASCADE;


--new querys 7 

ALTER TABLE "Transportes" DROP CONSTRAINT "Transportes_tipoId_fkey";

-- DropForeignKey
ALTER TABLE "Transportes" DROP CONSTRAINT "Transportes_usuarioId_fkey";


-- AlterTable
ALTER TABLE "Transportes" ALTER COLUMN "tipoId" SET NOT NULL,
ALTER COLUMN "usuarioId" SET NOT NULL;

-- AddForeignKey
ALTER TABLE "Transportes" ADD CONSTRAINT "Transportes_tipoId_fkey" FOREIGN KEY ("tipoId") REFERENCES "TipoTransporte"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Transportes" ADD CONSTRAINT "Transportes_usuarioId_fkey" FOREIGN KEY ("usuarioId") REFERENCES "Usuarios"("id") ON DELETE RESTRICT ON UPDATE CASCADE;


--new querys 8

ALTER TABLE "Transportes" ADD COLUMN     "actualizadoEn" TIMESTAMP(3) NOT NULL,
ADD COLUMN     "creadoEn" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "isActive" BOOLEAN NOT NULL DEFAULT true;


--new querys 9 

ALTER TABLE "Carga" ADD COLUMN     "actualizadoEn" TIMESTAMP(3) NOT NULL,
ADD COLUMN     "creadoEn" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "isActive" BOOLEAN NOT NULL DEFAULT true;
