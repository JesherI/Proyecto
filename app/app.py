from flask import Flask, render_template

from views.user_views import user_views
#Asiganamos el nombre de la aplicasión
app = Flask(__name__)

app.register_blueprint(user_views)
app.config['SECRET_KEY'] = 'my secret key'

#rutas de la web
@app.route('/')
def index():
    return render_template('index/index.html')

def pagina_no_encontrada(error):
    return render_template('errors/404.html'), 404

#Ejecuta el programa donde __name__ = __name__ 
#Agregamos la depuración  y el puerto
if __name__ == __name__:
    app.register_error_handler(404,pagina_no_encontrada)
    app.run(debug=True, port=5000)