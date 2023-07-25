from .db import get_connection
from werkzeug.security import generate_password_hash, check_password_hash

mydb = get_connection()

class User:

    def __init__(self,
                 nombre,
                 apellido_paterno,
                 apellido_materno,
                 nombre_de_usuario,
                 tipo_usuario,
                 direccion,
                 telefono,
                 contrasena,
                 foto_perfil='',
                 id=None):
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

    def save(self):
        if self.id is None:
            with mydb.cursor() as cursor:
                self.contrasena = generate_password_hash(self.contrasena)
                sql = "INSERT INTO usuarios (nombre,apellido_paterno,apellido_materno,nombre_de_usuario,tipo_usuario,direccion,telefono,contrasena,foto_perfil ) VALUES(%s,%s,%s,%s,%s,%s,%s,%s,%s)"
                val = (self.nombre, self.apellido_paterno, self.apellido_materno, self.nombre_de_usuario, self.tipo_usuario, self.direccion, self.telefono, self.contrasena, self.foto_perfil)
                cursor.execute(sql, val)
                mydb.commit()
                self.id = cursor.lastrowid
                return self.id
        else:
            with mydb.cursor() as cursor:
                sql = 'UPDATE usuarios SET nombre = %s, apellido_paterno = %s , apellido_materno = %s, nombre_de_usuario = %s, tipo_usuario = %s, direccion = %s, telefono = %s, contrasena = %s'
                sql += 'WHERE id = %s'
                val = (self.nombre, self.apellido_paterno, self.apellido_materno, self.nombre_de_usuario, self.tipo_usuario, self.direccion, self.telefono, self.contrasena, self.id)
                cursor.execute(sql, val)
                mydb.commit()
                return self.id
    
    def delete(self):
        with mydb.cursor() as cursor:
            sql = f"DELETE FROM usuarios WHERE id = { self.id }"
            cursor.execute(sql)
            mydb.commit()
            return self.id
        
    @staticmethod
    def __get__(id):
        with mydb.cursor(dictionary=True) as cursor:
            sql = f"SELECT * FROM usuarios WHERE id = { id }"
            cursor.execute(sql)

            user = cursor.fetchone()

            if user:
                user = User(nombre_de_usuario=user["nombre_de_usuario"],
                            contrasena=user['contrasena'],
                            nombre=user['nombre'],
                            apellido_paterno=user['apellido_paterno'],
                            apellido_materno=user['apellido_materno'],
                            tipo_usuario=user["tipo_usuario"],
                            direccion=user["direccion"],
                            telefono=user["telefono"],
                            foto_perfil=user["foto_perfil"],
                            id=id)
                return user
            
            return None
        
    @staticmethod
    def check_username(nombre_de_usuario):
        with mydb.cursor(dictionary=True) as cursor:
            sql = f"SELECT * FROM usuarios WHERE nombre_de_usuario = '{ nombre_de_usuario }'"
            cursor.execute(sql)

            user = cursor.fetchone()

            if user:
                return 'Usuario existente'
            else:
                return None
    
    def update_password(self, new_password):
        # Aquí puedes agregar tus propios criterios de validación para la contraseña,
        # por ejemplo, longitud mínima, caracteres especiales, etc.
        # Puedes usar form.validate_field_name(data) para validar campos específicos.
        # Ejemplo: form.validate_password(new_password)

        # Encripta la nueva contraseña
        hashed_password = generate_password_hash(new_password)
        self.contrasena = hashed_password

    @staticmethod
    def get_by_password(nombre_de_usuario, contrasena):
        with mydb.cursor(dictionary=True) as cursor:
            sql = "SELECT id, nombre_de_usuario, contrasena FROM usuarios WHERE nombre_de_usuario = %s"
            val = (nombre_de_usuario)
            cursor.execute(sql, val)
            user = cursor.fetchone()

            if user != None:
                if check_password_hash(user["contrasena"], contrasena):
                    return User.__get__(user["id"])
                return None
        
    @staticmethod
    def get_all():
        users = []
        with mydb.cursor(dictionary=True) as cursor:
            sql = f"SELECT * FROM usuarios"
            cursor.execute(sql)
            result = cursor.fetchall()
            for user in result:
                users.append(
                    User(nombre_de_usuario=user["nombre_de_usuario"],
                         contrasena=user["contrasena"],
                         nombre=user["nombre"],
                         apellido_paterno=user["apellido_paterno"],
                         apellido_materno=user["apellido_materno"],
                         tipo_usuario=user["tipo_usuario"],
                         direccion=user["direccion"],
                         telefono=user["telefono"],
                         foto_perfil=user["foto_perfil"],
                         id=user["id"])
                )
        return users

    def __str__(self):
        return f"{self.nombre_de_usuario} {self.nombre} {self.apellido_paterno} {self.apellido_materno}"
