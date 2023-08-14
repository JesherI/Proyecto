from flask import Blueprint, render_template
from flask_login import login_required
from models.db import get_connection

reportes_views = Blueprint('reportes_views', __name__)

@reportes_views.route('/reportes/')
@login_required
def reportes_semanal():
    connection = get_connection()
    cursor = connection.cursor()

    query_abonos = "SELECT fecha, total_abonos AS total_abonos FROM vista_abonos_ultimos_7_dias GROUP BY fecha ORDER BY fecha DESC"
    cursor.execute(query_abonos)
    abonos_data = [{"fecha": str(row[0]), "total_abonos": float(row[1])} for row in cursor.fetchall()]

    cursor.close()
    connection.close()

    fecha_labels = [item["fecha"] for item in abonos_data]
    total_abonos = [item["total_abonos"] for item in abonos_data]

    connection = get_connection()
    cursor = connection.cursor()

    query_totals = """
    SELECT
        COUNT(p.id_producto) AS total,
        COUNT(CASE WHEN p.estado = 'Disponible' THEN 1 END) AS total_disponibles,
        COUNT(CASE WHEN p.estado = 'Apartado' THEN 1 END) AS total_apartados,
        COUNT(CASE WHEN p.estado = 'Vendido' THEN 1 END) AS total_vendidos
    FROM productos p;
    """

    query_total_earnings = "SELECT SUM(abono) AS total_earnings FROM compras"

    cursor.execute(query_totals)
    row_totals = cursor.fetchone()

    cursor.execute(query_total_earnings)
    row_earnings = cursor.fetchone()

    cursor.close()
    connection.close()

    total = row_totals[0]
    total_disponibles = row_totals[1]
    total_apartados = row_totals[2]
    total_vendidos = row_totals[3]
    total_earnings = row_earnings[0]

    return render_template('users/reporte/reportes.html',
                           fecha_labels=fecha_labels,
                           total_abonos=total_abonos,
                           total=total,
                           total_disponibles=total_disponibles,
                           total_apartados=total_apartados,
                           total_vendidos=total_vendidos,
                           total_earnings=total_earnings)
