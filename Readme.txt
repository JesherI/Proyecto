Hay que instalar esto y usa los siguientes comandos en el siguiente orden
python -m venv venv
source venv/Script/activate
pip install flask
pip install flask-mysqldb
pip install flask-wtf 
pip install Flask-Login

Les agrego la base de datos por el momento tiene solo una tabla y la base de  datos se tiene que llamar prueba

<!-- <td>
                     Aquí está el contenido principal 
                    <a href="{{ url_for('update_user', user_id=user.id) }}">
                        <i class="fas fa-edit"></i> Actualizar
                    </a>
                    <a href="{{ url_for('delete_user', user_id=user.id) }}" class="delete-button">
                        <i class="fas fa-trash-alt"></i> Borrar
                        
                    </a>
                </td>
            -->