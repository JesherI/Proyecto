from flask_wtf import FlaskForm
from wtforms import (StringField, PasswordField, SubmitField, ValidationError, SelectField)
from wtforms.validators import DataRequired, EqualTo, Length
from flask_wtf.file import FileField, FileRequired, FileAllowed

from models.users import User

class RegisterForm(FlaskForm):
    nombre_de_usuario = StringField ('Nombre de usuario', validators=[DataRequired()])
    contrasena=PasswordField('Contrasena', validators=[DataRequired(), EqualTo('password_confirm', message= 'Las contraseñas deben de ser igules')])
    password_confirm = PasswordField('Password Confirm', validators=[DataRequired()])
    nombre=StringField('nombre', validators=[DataRequired()])
    apellido_paterno=StringField('apellido_paterno', validators=[DataRequired()])
    apellido_materno=StringField('apellido_materno', validators=[DataRequired()])
    tipo_usuario = SelectField('Tipo de usuario', choices=[('admin', 'Administrador'), ('cajero', 'Cajero')], validators=[DataRequired()])
    direccion=StringField('direccion', validators=[DataRequired()])
    telefono=StringField('telefono', validators=[DataRequired()])
    submit = SubmitField('Registrar')


    def validate_nombre_de_usuario(self, field):
        if User.check_username(field.data):
            raise ValidationError('El nombre de usuario y existe')
