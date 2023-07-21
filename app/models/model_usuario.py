from .entiti.User import Usuario

class ModelUser():

    @classmethod
    def login(self,db,usuario):
        try:
            cursor=db.connection.cursor()
            sql="""SELECT id, nombre_de_usuario, contrasena FROM usuarios
                WHERE nombre_de_usuario =  '{}'""".format(usuario.nombre_de_usuario)
            cursor.execute(sql)
            row = cursor.fetchone()
            if row != None:
                usuario=Usuario(row[0],row[1],Usuario.check_password(row[2], usuario.contrasena))
                return usuario
            else:
                return None
        except Exception as ex:
            raise Exception(ex)