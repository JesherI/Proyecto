from .entiti.User import Usuario

class ModelUser():
    @classmethod
    def login(cls, db, usuario):
        try:
            cursor = db.connection.cursor()
            sql = "SELECT id, nombre, apellido_paterno, apellido_materno, nombre_de_usuario, tipo_usuario, direccion, telefono, contrasena, foto_perfil FROM usuarios WHERE nombre_de_usuario = %s AND tipo_usuario = %s"
            cursor.execute(sql, (usuario.nombre_de_usuario, usuario.tipo_usuario))
            row = cursor.fetchone()
            if row is not None:
                usuario = Usuario(row[0], row[1], row[2], row[3], row[4], row[5], row[6], row[7],Usuario.check_password(row[8], usuario.contrasena), row[9])
                return usuario
            else:
                return None
        except Exception as ex:
            raise Exception(ex)

        
    @classmethod
    def get_by_id(cls, db, id):
        try:
            cursor = db.connection.cursor()
            sql = "SELECT id, nombre, apellido_paterno, apellido_materno, nombre_de_usuario, tipo_usuario, direccion, telefono, contrasena, foto_perfil FROM usuarios WHERE id = %s"
            cursor.execute(sql, (id,))
            row = cursor.fetchone()
            if row is not None:
                logged_user = Usuario(row[0], row[1], row[2], row[3], row[4], row[5], row[6], row[7], None, row[8])
                return logged_user
            else:
                return None
        except Exception as ex:
            raise Exception(ex)
