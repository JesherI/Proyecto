from .entiti.User import Usuario

class ModelUser():
    @classmethod
    def login(cls, db, usuario):
        try:
            cursor = db.connection.cursor()
            sql = "SELECT id, nombre_de_usuario, tipo_usuario, contrasena FROM usuarios WHERE nombre_de_usuario = %s AND tipo_usuario = %s"
            cursor.execute(sql, (usuario.nombre_de_usuario, usuario.tipo_usuario))
            row = cursor.fetchone()
            if row is not None:
                usuario = Usuario(row[0], row[1], row[2], Usuario.check_password(row[3], usuario.contrasena))
                return usuario
            else:
                return None
        except Exception as ex:
            raise Exception(ex)
