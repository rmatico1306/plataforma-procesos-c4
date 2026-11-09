workspace "Plataforma de Procesos" "Arquitectura C4 de la Plataforma de Procesos BBP-GA-PP-205" {
	
	model {
		
		// ============================================================
		// PERSONAS
		// ============================================================
		
		solicitante = person "Responsable de Área" "Genera solicitudes de creación o actualización de procedimientos y participa en el visto bueno."
		
		analista = person "Analista de Procesos" "Gestiona el plan de trabajo, sprints, documentación y versiones de trabajo."
		
		coordinador = person "Coordinador de Procesos" "Revisa y valida documentos y controla el avance del procedimiento."
		
		jefeProcesos = person "Jefe de Procesos" "Administra solicitudes, nomenclaturas, usuarios, permisos y liberaciones documentales."
		
		firmante = person "Revisor / Autorizador" "Revisa, autoriza o rechaza documentos dentro del flujo de firma."
		
		colaborador = person "Colaborador GS" "Consulta documentos vigentes de acuerdo con sus permisos y categoría documental."
		
		// Personas nuevas
		externo = person "Usuario Externo" "Consulta documentos publicados que le hayan sido asignados explícitamente."
		gerenteAdmin = person "Gerente Administrativo" "Aprueba el Programa Anual de actualización y administra roles y permisos."
		revisorExterno = person "Revisor Externo" "Revisa documentos mediante una liga enviada por correo y emite comentarios o visto bueno."
		desempeno = person "Área de Desempeño" "Define metas y umbrales de los indicadores calculados con los datos de la plataforma."
		
		// ============================================================
		// SISTEMAS EXTERNOS
		// ============================================================
		
		
		kiosko = softwareSystem "Servicio de Login Kiosko" "Servicio corporativo de autenticación de usuarios internos. Su respuesta incluye identificador, nómina, nombre, departamento, puesto, correo y estatus del colaborador." "External System"
		
		sassip = softwareSystem "SASSIP - Sistema de Asistencia" "Sistema corporativo previsto como fuente de catálogos de áreas organizacionales. Endpoints, estructura y alcance de los catálogos pendientes de confirmación técnica." "External System"
		
		correo = softwareSystem "Servicio de Correo Corporativo" "Servicio utilizado para envío de notificaciones, revisión externa y solicitudes de firma." "External System"
		// Sistema externo nuevo
		tableroDesempeno = softwareSystem "Tablero de Indicadores de Desempeño" "Tablero del área de Desempeño que calcula y visualiza los indicadores del proceso documental a partir de los datos de la plataforma." {
			tags "External System"
		}
		
		// ============================================================
		// SISTEMA PRINCIPAL
		// ============================================================
		
		plataforma = softwareSystem "Plataforma de Procesos" "Gestiona solicitudes, documentación, revisiones, firmas, nomenclaturas, repositorios, permisos e indicadores." {
			
			// ========================================================
			// CONTENEDORES C2
			// ========================================================
			
			web = container "Aplicación Web" "Interfaz web utilizada por usuarios internos y externos." "React / Vue / Angular"
			
			api = container "Backend API" "Implementa reglas de negocio, workflow documental, seguridad, solicitudes y publicación." "Laravel / .NET / Spring Boot" {
				
				// ====================================================
				// COMPONENTES C3
				// ====================================================
				
				auth = component "Módulo de Autenticación" "Gestiona sesiones, autenticación mediante el servicio de Login Kiosko y acceso de usuarios externos."
				
				solicitudes = component "Módulo de Solicitudes" "Gestiona creación, autorización, regreso y seguimiento de solicitudes."
				
				workflow = component "Motor de Workflow" "Controla los cambios de estado del procedimiento y del documento."
				
				tareas = component "Plan de Trabajo y Sprint" "Gestiona tareas, actividades, fechas, prioridades, complejidad y avance."
				
				documentos = component "Gestión Documental" "Administra documentos, versiones de trabajo, carga, consulta y metadatos."
				
				revision = component "Módulo de Revisión" "Gestiona revisión del Coordinador y revisión externa."
				
				firmas = component "Módulo de Firmas" "Administra las etapas secuenciales de Revisor y Autorizador y la validación sustitutiva."
				
				nomenclaturas = component "Módulo de Nomenclaturas" "Genera y administra nomenclaturas activas, bajas y reutilizables."
				
				concentrado = component "Módulo de Folios y Concentrado" "Gestiona folios del concentrado documental y datos de liberación."
				
				repositorios = component "Gestor de Repositorios" "Controla documentos Vigentes, Obsoletos y Dados de Baja."
				
				permisos = component "Módulo de Roles y Permisos" "Administra perfiles, permisos funcionales y módulos accesibles."
				
				accesoDocumental = component "Control de Acceso Documental" "Evalúa estatus, asignaciones especiales, categoría, puesto, área y permisos."
				
				lectura = component "Control de Lectura" "Registra la apertura de documentos y calcula cumplimiento documental."
				
				indicadores = component "Módulo de Indicadores" "Calcula métricas de liberación, tiempos, cumplimiento y productividad."
				
				auditoria = component "Servicio de Auditoría" "Registra eventos relevantes y trazabilidad de las operaciones."
				
				notificaciones = component "Servicio de Notificaciones" "Genera solicitudes de notificación y correo para eventos del workflow."
			}
			
			worker = container "Worker Asíncrono" "Procesa tareas en segundo plano como notificaciones, publicación documental e indicadores." "Worker / Queue Consumer"
			
			db = container "Base de Datos" "Almacena solicitudes, tareas, documentos, versiones, firmas, permisos, auditoría e indicadores." "PostgreSQL" "Database"
			
			storage = container "Repositorio de Archivos" "Almacena documentos, versiones, evidencias y archivos asociados." "Amazon S3" "Storage"
			
			queue = container "Broker de Mensajes" "Desacopla tareas asíncronas del flujo transaccional." "Redis" "Queue"
		}
		
		
		// ============================================================
		// RELACIONES C1
		// ============================================================
		
		solicitante -> plataforma "Genera y consulta solicitudes"
		analista -> plataforma "Gestiona documentación y plan de trabajo"
		coordinador -> plataforma "Revisa y valida documentos"
		jefeProcesos -> plataforma "Administra la plataforma y el proceso documental"
		firmante -> plataforma "Revisa, firma o rechaza documentos"
		colaborador -> plataforma "Consulta documentación vigente"
		externo -> plataforma "Consulta documentos autorizados"
		gerenteAdmin -> plataforma "Aprueba el programa anual y administra roles y permisos"
		revisorExterno -> plataforma "Emite comentarios o visto bueno desde una liga"
		
		plataforma -> kiosko "Valida el acceso de colaboradores internos y obtiene datos básicos del usuario"
		plataforma -> sassip "Consulta catálogos de áreas organizacionales"
		plataforma -> correo "Envía notificaciones, ligas de revisión y solicitudes de firma"
		correo -> firmante "Envía solicitudes de firma"
		correo -> revisorExterno "Envía liga de acceso al documento"
		correo -> solicitante "Notifica la liberación del procedimiento"
		tableroDesempeno -> plataforma "Consume datos de liberación, tiempos y cumplimiento"
		desempeno -> tableroDesempeno "Define metas y umbrales, consulta indicadores"
		
		// ============================================================
		// RELACIONES C2
		// ============================================================
		
		solicitante -> web "Utiliza" "HTTPS"
		analista -> web "Utiliza" "HTTPS"
		coordinador -> web "Utiliza" "HTTPS"
		jefeProcesos -> web "Utiliza" "HTTPS"
		firmante -> web "Utiliza" "HTTPS"
		colaborador -> web "Utiliza" "HTTPS"
		externo -> web "Utiliza" "HTTPS"
		web -> api "Consume servicios" "REST/JSON sobre HTTPS"
		api -> db "Consulta y persiste información" "SQL"
		api -> storage "Carga y consulta documentos" "HTTPS / S3 API"
		api -> queue "Publica tareas asíncronas" "Broker de mensajes"
		
		worker -> queue "Consume mensajes" "Broker de mensajes"
		worker -> db "Consulta y actualiza datos" "SQL"
		worker -> storage "Gestiona archivos" "S3 API"
		
		api -> kiosko "Autentica usuarios internos y obtiene datos del colaborador" "API corporativa / HTTPS"
		api -> sassip "Consulta catálogos de áreas organizacionales (contrato por confirmar)" "API corporativa (por confirmar)"
		
		worker -> correo "Envía notificaciones" "SMTP / API"
		
		gerenteAdmin -> web "Utiliza" "HTTPS"
		revisorExterno -> web "Utiliza" "HTTPS"
		tableroDesempeno -> api "Consulta datos de indicadores" "REST/JSON sobre HTTPS"
		
		
		// ============================================================
		// RELACIONES C3
		// ============================================================
		
		web -> auth "Solicita autenticación"
		web -> solicitudes "Gestiona solicitudes"
		web -> tareas "Gestiona actividades"
		web -> documentos "Carga y consulta documentos"
		web -> revision "Ejecuta revisiones"
		web -> firmas "Firma o rechaza documentos"
		web -> nomenclaturas "Gestiona nomenclaturas"
		web -> repositorios "Consulta documentos"
		web -> permisos "Administra roles y permisos"
		web -> indicadores "Consulta indicadores"
		
		auth -> kiosko "Valida credenciales internas"
		
		solicitudes -> workflow "Inicia y actualiza flujo"
		solicitudes -> tareas "Genera asignación y plan de trabajo"
		solicitudes -> auditoria "Registra eventos"
		
		tareas -> documentos "Relaciona trabajo con documento"
		tareas -> auditoria "Registra cambios"
		
		documentos -> storage "Almacena archivos"
		documentos -> db "Persiste metadatos"
		documentos -> auditoria "Registra versiones"
		
		revision -> workflow "Actualiza estado del documento"
		revision -> documentos "Consulta versión vigente"
		revision -> notificaciones "Genera notificación"
		
		firmas -> workflow "Registra firma, rechazo y actualiza flujo"
		firmas -> documentos "Consulta documento"
		firmas -> auditoria "Registra firma o rechazo"
		firmas -> notificaciones "Genera notificación"
		
		workflow -> repositorios "Solicita publicación o movimiento documental"
		workflow -> queue "Genera eventos asíncronos"
		
		nomenclaturas -> db "Consulta consecutivos y nomenclaturas"
		nomenclaturas -> auditoria "Registra alta, reutilización o baja"
		
		concentrado -> db "Gestiona folios y concentrado"
		
		repositorios -> storage "Gestiona documentos físicos"
		repositorios -> db "Actualiza estatus documental"
		repositorios -> auditoria "Registra publicación, obsolescencia o baja"
		
		permisos -> db "Gestiona roles y permisos"
		
		accesoDocumental -> permisos "Consulta permisos"
		accesoDocumental -> db "Consulta puesto, área, categoría y asignaciones"
		
		lectura -> db "Registra aperturas"
		lectura -> indicadores "Proporciona métricas de lectura"
		
		indicadores -> db "Consulta información operacional"
		
		auditoria -> db "Persiste trazabilidad"
		
		notificaciones -> queue "Publica mensajes de notificación"
		
		worker -> notificaciones "Procesa notificaciones"
		
		
		// ============================================================
		// DEPLOYMENT - MVP DE BAJO COSTO
		// ============================================================
		
		mvp = deploymentEnvironment "MVP" {
			
			deploymentNode "AWS" "Infraestructura AWS de bajo costo para el MVP." "Amazon Web Services" {
				
				deploymentNode "VPC Plataforma de Procesos" "Red de la solución MVP." "AWS VPC" {
					
					deploymentNode "EC2 Aplicación" "Servidor único para la capa web y aplicación mediante Docker Compose." "Amazon EC2 + Docker Compose" {
						
						deploymentNode "Contenedores Aplicación" "Servicios principales del MVP." "Docker Compose" {
							containerInstance web
							containerInstance api
							containerInstance worker
						}
						
						deploymentNode "Redis Local" "Broker de mensajes para tareas asíncronas del Worker." "Redis" {
							containerInstance queue
						}
					}
					
					deploymentNode "RDS PostgreSQL Single-AZ" "Base de datos administrada de bajo costo para el MVP." "Amazon RDS PostgreSQL Single-AZ" {
						containerInstance db
					}
					
					deploymentNode "S3 Documental" "Almacenamiento de documentos, versiones y evidencias." "Amazon S3" {
						containerInstance storage
					}
				}
			}
		}
		
		
	}
	
	
	// ================================================================
	// VISTAS
	// ================================================================
	
	views {
		
		// ============================================================
		// C1 - SYSTEM CONTEXT
		// ============================================================
		
		systemContext plataforma "C1-Contexto" {
			
			include *
			include desempeno
			autoLayout lr
			
			title "C1 - Contexto de la Plataforma de Procesos"
			
			description "Personas y sistemas externos que interactúan con la Plataforma de Procesos."
		}
		
		
		// ============================================================
		// C2 - CONTENEDORES
		// ============================================================
		
		container plataforma "C2-Contenedores" {
			
			include solicitante
			include analista
			include coordinador
			include jefeProcesos
			include firmante
			include colaborador
			include externo
			
			include web
			include api
			include worker
			include db
			include storage
			include queue
			
			include kiosko
			include sassip
			include correo
			
			include gerenteAdmin
			include revisorExterno
			include tableroDesempeno
			
			autoLayout lr
			
			title "C2 - Contenedores de la Plataforma de Procesos"
			
			description "Arquitectura de contenedores de la Plataforma de Procesos."
		}
		
		
		// ============================================================
		// C3 - COMPONENTES BACKEND
		// ============================================================
		
		component api "C3-Backend" {
			
			include *
			
			autoLayout lr
			
			title "C3 - Componentes del Backend API"
			
			description "Componentes funcionales que conforman el Backend API."
		}
		
		
		// ============================================================
		// VISTA DINÁMICA
		//
		// CORRECCIÓN:
		// El scope ahora es API porque queremos utilizar componentes.
		// ============================================================
		
		dynamic api "Flujo-Publicacion" {
			
			title "Flujo de Firma y Publicación Automática"
			
			firmante -> web "Firma el documento"
			
			web -> firmas "Envía la firma al Backend"
			
			firmas -> workflow "Registra la firma y valida si el flujo está completo"
			
			workflow -> queue "Si las firmas están completas, publica evento DocumentoAutorizado"
			
			worker -> queue "Consume el evento DocumentoAutorizado"
			
			worker -> db "Actualiza versión, estatus y fecha de publicación"
			
			worker -> storage "Publica el documento como versión vigente"
			
			worker -> correo "Envía notificación de liberación"
			
			autoLayout lr
			
			description "Flujo automático ejecutado cuando se completa la totalidad de firmas requeridas."
		}
		
		
		// ============================================================
		// DEPLOYMENT - MVP DE BAJO COSTO
		// ============================================================
		
		deployment plataforma mvp "Deployment-MVP" {
			
			include *
			
			autoLayout lr
			
			title "Deployment - MVP de Bajo Costo"
			
			description "MVP de bajo costo con una única EC2 ejecutando Web, Backend, Worker y Redis mediante Docker Compose; RDS PostgreSQL Single-AZ para datos y S3 para documentos."
		}
		
		
		// ============================================================
		// ESTILOS
		// ============================================================
		
		styles {
			
			element "Person" {
				shape Person
				background #08427B
				color #ffffff
			}
			
			element "Software System" {
				background #1168bd
				color #ffffff
			}
			
			element "Container" {
				background #438dd5
				color #ffffff
			}
			
			element "Component" {
				background #85bbf0
				color #000000
			}
			
			element "Database" {
				shape Cylinder
				background #438dd5
				color #ffffff
			}
			
			element "Storage" {
				shape Folder
				background #438dd5
				color #ffffff
			}
			
			element "Queue" {
				shape Pipe
				background #438dd5
				color #ffffff
			}
			element "External System" {
				background #999999
				color #ffffff
			}
		}
	}
}
