from flask import Blueprint, render_template
from flask_login import login_required
from models.db import get_connection

reportes_views = Blueprint('reportes_views', __name__)

@reportes_views.route('/reportes/')
@login_required
def reportes_semanal():
    connection = get_connection()
    cursor = connection.cursor()

    query = "SELECT fecha, total_abonos AS total_abonos FROM vista_abonos_ultimos_7_dias GROUP BY fecha ORDER BY fecha DESC"
    cursor.execute(query)
    data = [{"fecha": str(row[0]), "total_abonos": float(row[1])} for row in cursor.fetchall()]

    cursor.close()
    connection.close()

    fecha_labels = [item["fecha"] for item in data]
    total_abonos = [item["total_abonos"] for item in data]


    return render_template('users/reporte/reportes.html', fecha_labels=fecha_labels, total_abonos=total_abonos)
