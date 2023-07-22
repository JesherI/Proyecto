from flask import Blueprint, render_template, url_for, redirect, current_app,current_app
from models.users import User
from forms.user_forms import RegisterForm
from werkzeug.utils import secure_filename
from models.db import get_connection
from flask_login import LoginManager, login_user, logout_user ,login_required
import os



user_views = Blueprint('user',__name__)
mysql = get_connection()

@user_views . route('/registro/', methods=('GET', 'POST'))
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
        foto_perfil = form.foto_perfil.data

        if foto_perfil:  # Verificar si se ha enviado una imagen
            nombre_archivo = secure_filename(foto_perfil.filename)
            foto_perfil.save(os.path.join(current_app.root_path, 'static/img/profile', nombre_archivo))
            direccion_foto = 'img/profile/' + nombre_archivo
        else:
            direccion_foto = 'img/foto_default.jpg'  # Ruta de la foto predeterminada

        user = User(nombre, apellido_paterno, apellido_materno, nombre_de_usuario, tipo_usuario, direccion, telefono, contrasena, direccion_foto)
        user.save()
        return redirect(url_for('user.register'))
    
    return render_template('users/registro.html', form=form)
    
@user_views . route('/Home_Admin')
@login_required
def index_admin():
    return render_template('users/admin.html')

@user_views . route('/Home_Cajero')
@login_required
def index_cajero():
    return render_template('users/cajero.html')

@user_views.route('/usuarios/')
@login_required
def usuarios():
    users = User.get_all()
    return render_template('users/usuarios.html', users=users)