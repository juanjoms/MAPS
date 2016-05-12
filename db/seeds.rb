# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#company
Company.create(id:1, name: 'CIMAT', description: 'Centro de Investigación en Matemáticas')

#Cuestionarios
ProcessArea.create(id: 1, name: 'Planificación de Proyectos', description: 'Un área de proceso de Gestión de Proyectos en el nivel de madurez 2', purpose: 'El propósito de la Planificación del Proyecto (PP) es establecer y mantener
planes que definan las actividades del proyecto.')

#Specifics Goals
SpecificGoal.create(id: 1, name: 'Establecer las estimaciones', description: '', process_areas_id: 1)
SpecificGoal.create(id: 2, name: 'Desarrollar un plan del proyecto', description: '', process_areas_id: 1)
SpecificGoal.create(id: 3, name: 'Obtener el compromiso con el plan', description: '', process_areas_id: 1)

#SpecificGoal #1
Practice.create(name: 'Estimar el alcance del proyecto', question: '¿Se estima el alcance del proyecto?', examples: 'Ejemplo: Establecer un WBS (Estructura de descomposición de trabajo) para estimar el alcance del proyecto.', added_value: 0, specific_goals_id: 1)
Practice.create(name: 'Establecer las estimaciones de los atributos de los productos de trabajo y de las tareas', question: '¿Se establecen las estimaciones de los atributos de los productos de trabajo y de las tareas?', examples: 'Ejemplos de atributos para estimar son:
* Número y complejidad de los requisitos.
* Número y complejidad de las interfaces.
* Número de funciones.
* Puntos función.
* Líneas de código fuente.', added_value: 0, specific_goals_id: 1)
Practice.create(name: 'Definir las fases del ciclo de vida del proyecto', question: '¿Se definen las fases del ciclo de vida del proyecto?', examples: 'Ejemplo de productos de trabajo: Fases del ciclo de vida del proyecto.', added_value: 0, specific_goals_id: 1)
Practice.create(name: 'Estimar el esfuerzo y el coste', question: '¿Se estima el esfuerzo y coste?', examples: 'Ejemplos de productos de trabajo:
* Análisis razonado de la estimación.
* Estimaciones del esfuerzo del proyecto.
* Estimaciones del coste del proyecto.', added_value: 0, specific_goals_id: 1)

#SpecificGoal #2
Practice.create(name: 'Establecer el presupuesto y el calendario', question: '¿Se establece el presupuesto y el calendario? ', examples: 'Ejemplo de productos de trabajo: Fases del ciclo de vida del proyecto.', added_value: 0, specific_goals_id: 2)
Practice.create(name: 'Identificar los riesgos del proyecto', question: '¿Se identifican los riesgos del proyecto? ', examples: 'Ejemplo de productos de trabajo:
* Riesgos identificados
* Impactos y probabilidad de ocurrencia de los riesgos
* Prioridades de los riesgo ', added_value: 0, specific_goals_id: 2)
Practice.create(name: 'Planificar la gestión de los datos', question: '¿Se planifica la gestión de los datos del proyecto?', examples: 'Ejemplo de productos de trabajo:
* Plan para la gestión de datos
* Lista maestra de datos gestionados
* Calendario para la recogida de datos del proyecto
* Listado de datos del proyecto a recoger', added_value: 0, specific_goals_id: 2)
Practice.create(name: 'Planificar los recursos del proyecto', question: '¿Se planifican los recursos del proyecto?', examples: 'Ejemplo de productos de trabajo:
* Paquetes de trabajo.
* Diccionario de tareas de la WBS.
* Requisitos de personal basados en el tamaño y el alcance del proyecto.
* Lista de instalaciones y equipamientos críticos.
* Lista de requisitos de administración del proyecto. ', added_value: 0, specific_goals_id: 2)
Practice.create(name: 'Planificar el conocimiento y las habilidades necesarias', question: 'Se planifica el conocimiento y las habilidades necesarias? ', examples: 'Ejemplo de productos de trabajo:
* Inventario de habilidades necesarias.
* Planes de personal y nuevas contrataciones.
* Bases de datos (p. ej., habilidades, formación).
* Planes de formación.', added_value: 0, specific_goals_id: 2)
Practice.create(name: 'Planificar la involucración de las partes interesadas', question: '¿Se planifica la involucración de las partes interesadas? ', examples: 'Ejemplo de productos de trabajo: Plan para la involucración de las partes interesadas', added_value: 0, specific_goals_id: 2)
Practice.create(name: 'Establecer el plan de proyecto', question: '¿Se establece el plan del proyecto? ', examples: 'Ejemplo de productos de trabajo: Plan global del proyecto', added_value: 0, specific_goals_id: 2)

#SpecificGoal #3
Practice.create(name: 'Revisar los planes que afectan al proyecto', question: '¿Se revisan los planes que afectan al proyecto?', examples: 'Ejemplo de productos de trabajo: Registro de la revisiones de los planes que afectan al proyecto.', added_value: 0, specific_goals_id: 3)
Practice.create(name: 'Conciliar los niveles de trabajo y de recursos', question: '¿Se concilian los niveles de trabajo y de recursos?', examples: 'Ejemplo de productos de trabajo:
* Métodos y parámetros de estimación correspondientes modificados (p. ej., mejores herramientas, uso de productos comerciales).
* Presupuestos renegociados.
* Calendarios modificados.
* Lista de requisitos modificada.', added_value: 0, specific_goals_id: 3)
Practice.create(name: 'Obtener el compromiso con el plan', question: '¿Se obtiene un compromiso con el plan?', examples: 'Ejemplo de productos de trabajo:
* Peticiones de compromisos documentadas.
* Compromisos documentados. ', added_value: 0, specific_goals_id: 3)
