from werkzeug.security import check_password_hash

class Usuario():

    def  __init__(self, id,nombre_de_usuario,contrasena) -> None:
        self.id = id
        self.nombre_de_usuario = nombre_de_usuario
        self.contrasena = contrasena
    
    @classmethod
    def check_password(self,hashed_password,contrasena):
        return check_password_hash(hashed_password,contrasena)