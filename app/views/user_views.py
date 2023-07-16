from flask import Blueprint, render_template, url_for, flash, redirect, abort
from models.users import User
from forms.user_forms import RegisterForm
from utils.file_handler import save_image

user_views = Blueprint('user',__name__)

@user_views . route('/usuarios/restro/', methods=('GET', 'POST'))
def register():
    form = RegisterForm()

    if form.validate_on_submit():
        nombre_de_usuario = form.nombre_de_usuario.data
        contrasena = form.contrasena.data
        nombre = form.nombre.data
        apellido_paterno = form.apellido_paterno.data
        apellido_materno = form.apellido_materno.data
        tipo_usuario = form.tipo_usuario.data
        direccion = form.direccion.data
        telefono = form.telefono.data

        user = User(nombre, apellido_paterno, apellido_materno, nombre_de_usuario, tipo_usuario, direccion, telefono, contrasena)
        user.save()
        return redirect(url_for('user.login'))
    return render_template('users/registro.html', form=form)