from werkzeug.security import check_password_hash
from flask_login import UserMixin

class Usuario(UserMixin):

    def  __init__(self,id,nombre,apellido_paterno,apellido_materno,nombre_de_usuario,tipo_usuario,direccion,telefono,contrasena,foto_perfil) -> None:
        self.id = id
        self.nombre = nombre
        self.apellido_paterno = apellido_paterno
        self.apellido_materno = apellido_materno
        self.nombre_de_usuario = nombre_de_usuario
        self.tipo_usuario = tipo_usuario
        self.direccion = direccion
        self.telefono = telefono
        self.contrasena = contrasena
        self.foto_perfil = foto_perfil

    @classmethod
    def check_password(cls, hashed_password, contrasena):
        return check_password_hash(hashed_password, contrasena)
