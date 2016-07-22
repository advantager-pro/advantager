#temporary seeds for production
#roles
dir = Role.where(name: "Director").first
dir.attributes = {name: "Manager", locale: :en}
dir.attributes = {name: "Director", locale: :es}
dir.save!

rh = Role.where(name: "RRHH").first
rh.attributes = {name: "HHRR", locale: :en}
rh.attributes = {name: "RRHH", locale: :es}
rh.save!

stk = Role.where(name: "Interesado").first
stk.attributes = {name: "Stakeholder", locale: :en}
stk.attributes = {name: "Interesado", locale: :es}
stk.save!

sup = Role.where(name: "Supervisor").first
sup.attributes = {name: "Supervisor", locale: :en}
sup.attributes = {name: "Supervisor", locale: :es}
sup.save!

wk = Role.where(name: "Realizador").first
wk.attributes = {name: "Worker", locale: :en}
wk.attributes = {name: "Realizador", locale: :es}
wk.save!

#priorities
low = IssuePriority.where(name: "Low").first
low.attributes = {name: "Low", locale: :en}
low.attributes = {name: "Baja", locale: :es}
low.save!

nor = IssuePriority.where(name: "Normal").first
nor.attributes = {name: "Normal", locale: :en}
nor.attributes = {name: "Normal", locale: :es}
nor.save!

hi = IssuePriority.where(name: "High").first
hi.attributes = {name: "High", locale: :en}
hi.attributes = {name: "Alta", locale: :es}
hi.save!

cri =IssuePriority.where(name: "Critical").first
cri.attributes = {name: "Critical", locale: :en}
cri.attributes = {name: "Crítica", locale: :es}
cri.save!

#TimeEntryActivity
all = TimeEntryActivity.all
pl = all.find{|e| e.name == "Planificacion"   }
pl.attributes = {name: "Planification", locale: :en}
pl.attributes = {name: "Planificación", locale: :es}
pl.save!

dev = all.find{|e| e.name == "Desarrollo"   }
dev.attributes = {name: "Development", locale: :en}
dev.attributes = {name: "Desarrollo", locale: :es}
dev.save!

inv = all.find{|e| e.name == "Investigacion"   }
inv.attributes = {name: "Investigation", locale: :en}
inv.attributes = {name: "Investigación", locale: :es}
inv.save!

tst = all.find{|e| e.name == "Pruebas"   }
tst.attributes = {name: "Testing", locale: :en}
tst.attributes = {name: "Pruebas", locale: :es}
tst.save!

doc = all.find{|e| e.name == "Documentacion"   }
doc.attributes = {name: "Documentation", locale: :en}
doc.attributes = {name: "Documentación", locale: :es}
doc.save!

evl = all.find{|e| e.name == "Evaluacion"   }
evl.attributes = {name: "Evaluation", locale: :en}
evl.attributes = {name: "Evaluación", locale: :es}
evl.save!


#Default Issue status
default_issue_status = IssueStatus.where(name: "New").first
default_issue_status.attributes = {name: "New", locale: :en}
default_issue_status.attributes = {name: "Nueva", locale: :es}
default_issue_status.save!

pro =IssueStatus.where(name: "In progress").first
pro.attributes = {name: "In progress", locale: :en}
pro.attributes = {name: "En progreso", locale: :es}
pro.save!

on_evl = IssueStatus.create(name: "En evaluacion", is_closed: false, default_done_ratio: nil)
on_evl.attributes = {name: "On evaluation", locale: :en}
on_evl.attributes = {name: "En evaluación", locale: :es}
on_evl.save!

clo = IssueStatus.where(name: "Closed").first
clo.attributes = {name: "Closed", locale: :en}
clo.attributes = {name: "Cerrada", locale: :es}
clo.save!

rej = IssueStatus.where(name: "Rejected").first
rej.attributes = {name: "Rejected", locale: :en}
rej.attributes = {name: "Rechazada", locale: :es}
rej.save!

mt = Tracker.create(name: "Hito", position: 1, is_in_roadmap: true, default_status_id: default_issue_status.id)
mt.attributes = {name: "Milestone", locale: :en}
mt.attributes = {name: "Hito", locale: :es}
mt.save!

ts = Tracker.where(name: "Task").first
ts.attributes = {name: "Task", locale: :en}
ts.attributes = {name: "Tarea", locale: :es}
ts.save!
