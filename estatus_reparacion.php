<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>Consultar Estatus de Reparación - Reparatech</title>
  <link rel="stylesheet" href="css/style.css">
</head>
<body>
  <?php 
    session_start();
    include 'includes/header.php'; 
  ?>
  
  <main class="contenedor" style="max-width: 800px; min-height: 80vh;">
    <div style="margin: 3rem 0 2rem;">
      <button class="btn btn-ghost" onclick="history.back()" style="margin-bottom: 1rem;">← Volver</button>
      <h2 style="font-size: 2.5rem; text-align: center; margin-bottom: 1rem;">Rastrea tu Reparación</h2>
      <p style="text-align: center; max-width: 500px; margin: 0 auto 2rem;">
        Ingresa el folio de tu servicio para ver el progreso en tiempo real.
      </p>
    </div>

    <section class="card fade-in">
      <form id="form-buscar-estatus" style="display: flex; gap: 1rem; flex-wrap: wrap;">
        <div style="flex: 1; min-width: 200px;">
          <input id="folio-buscar" type="text" placeholder="Ej: REP-20250001" required style="font-size: 1.1rem; padding: 1rem;">
        </div>
        <button type="submit" class="btn principal" style="padding: 0 2rem; font-size: 1.1rem;">🔍 Buscar</button>
      </form>
    </section>

    <div id="resultado-estatus" style="margin-top: 2rem;"></div>

    <!-- Sección de FAQ -->
    <section style="margin-top: 4rem;">
      <h3 style="text-align: center; margin-bottom: 2rem;">Preguntas Frecuentes</h3>
      <div style="display: grid; gap: 1rem;">
        <details class="card" style="cursor: pointer; padding: 1rem;">
          <summary style="font-weight: 600; list-style: none; display: flex; justify-content: space-between; align-items: center;">
            ¿Dónde encuentro mi folio?
            <span style="color: var(--primary);">+</span>
          </summary>
          <p style="margin-top: 1rem; color: var(--text-muted);">
            Tu folio aparece en la parte superior derecha del comprobante que recibiste al dejar tu equipo.
          </p>
        </details>

        <details class="card" style="cursor: pointer; padding: 1rem;">
          <summary style="font-weight: 600; list-style: none; display: flex; justify-content: space-between; align-items: center;">
            ¿Cuánto tiempo tarda la reparación?
            <span style="color: var(--primary);">+</span>
          </summary>
          <p style="margin-top: 1rem; color: var(--text-muted);">
            Depende de la complejidad, pero generalmente entre 3 a 7 días hábiles.
          </p>
        </details>
      </div>
    </section>
  </main>

  <?php include 'includes/footer.php'; ?>

  <script>
    document.getElementById('form-buscar-estatus').addEventListener('submit', async (e) => {
      e.preventDefault();
      const folio = document.getElementById('folio-buscar').value.trim();
      const out = document.getElementById('resultado-estatus');
      
      // Loading state
      out.innerHTML = `
        <div class="card" style="text-align: center; padding: 3rem;">
          <div style="font-size: 2rem; animation: spin 1s infinite linear;">⚙️</div>
          <p style="margin-top: 1rem;">Buscando tu reparación...</p>
        </div>
      `;

      try {
        const res = await fetch('php/api_reparaciones.php?accion=folio&folio=' + encodeURIComponent(folio))
          .then(async r => {
            if(!r.ok) throw new Error('Server error: ' + r.status);
            try {
              return await r.json();
            } catch(e) {
              throw new Error('Invalid JSON response');
            }
          });

        if (res.error) {
          out.innerHTML = `
            <div class="card" style="background: rgba(239, 68, 68, 0.1); border-color: var(--danger); text-align: center;">
              <div style="font-size: 3rem; margin-bottom: 1rem;">❌</div>
              <h3 style="color: var(--danger);">No encontrado</h3>
              <p>${res.error}</p>
            </div>`;
          return;
        }

        // Determine steps status
        const steps = ['Recibido', 'Diagnóstico', 'En Reparación', 'Concluido', 'Entregado'];
        // Map backend status to step index (approximate mapping)
        let currentStepIdx = 0;
        const statusLower = res.estatus.toLowerCase();
        
        if (statusLower.includes('recibido')) currentStepIdx = 0;
        else if (statusLower.includes('diagn')) currentStepIdx = 1;
        else if (statusLower.includes('repara') || statusLower.includes('espera')) currentStepIdx = 2;
        else if (statusLower.includes('concluido') || statusLower.includes('listo')) currentStepIdx = 3;
        else if (statusLower.includes('entregado')) currentStepIdx = 4;

        let timelineHTML = '<div class="timeline">';
        steps.forEach((step, idx) => {
          let statusClass = '';
          if (idx < currentStepIdx) statusClass = 'completed';
          if (idx === currentStepIdx) statusClass = 'active';
          
          timelineHTML += `
            <div class="timeline-step ${statusClass}">
              <div class="timeline-icon">
                ${idx < currentStepIdx ? '✓' : (idx + 1)}
              </div>
              <div class="timeline-label">${step}</div>
            </div>
          `;
        });
        timelineHTML += '</div>';

        const statusColor = res.estatus === 'Entregado' ? 'var(--success)' : (res.estatus === 'Concluido' ? 'var(--warning)' : 'var(--primary)');

        out.innerHTML = `
          <div class="card slide-up">
            <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 2rem; flex-wrap: wrap; gap: 1rem;">
              <div>
                <small style="text-transform: uppercase; letter-spacing: 1px; color: var(--text-muted);">Folio</small>
                <h2 style="margin: 0; color: var(--primary);">${res.folio}</h2>
              </div>
              <div style="text-align: right;">
                <span style="background: ${statusColor}; color: white; padding: 0.5rem 1rem; border-radius: 2rem; font-weight: 600; font-size: 0.9rem;">
                  ${res.estatus}
                </span>
              </div>
            </div>

            ${timelineHTML}

            <div style="background: var(--bg-body); padding: 1.5rem; border-radius: var(--radius-md); margin-top: 2rem;">
              <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(150px, 1fr)); gap: 1.5rem;">
                <div>
                  <small style="color: var(--text-muted);">Equipo</small>
                  <div style="font-weight: 600;">${res.equipo || 'Dispositivo'}</div>
                </div>
                <div>
                  <small style="color: var(--text-muted);">Fecha de Ingreso</small>
                  <div style="font-weight: 600;">${new Date(res.fecha_registro).toLocaleDateString('es-ES', { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' })}</div>
                </div>
                <div>
                  <small style="color: var(--text-muted);">Costo Estimado</small>
                  <div style="font-weight: 600; color: var(--success); font-size: 1.1rem;">$${Number(res.precio).toFixed(2)}</div>
                </div>
              </div>
              
              ${res.observaciones ? `
                <div style="margin-top: 1.5rem; padding-top: 1.5rem; border-top: 1px solid var(--border-subtle);">
                  <small style="color: var(--text-muted);">Observaciones del Técnico</small>
                  <p style="margin: 0.5rem 0 0;">${res.observaciones}</p>
                </div>
              ` : ''}
            </div>
          </div>
        `;
      } catch (e) {
        console.error(e);
        out.innerHTML = '<div class="card" style="border-color: var(--danger); color: var(--danger);">❌ Error de conexión. Intenta de nuevo.</div>';
      }
    });
  </script>
  <style>
    @keyframes spin { 100% { transform: rotate(360deg); } }
  </style>
</body>
</html>
