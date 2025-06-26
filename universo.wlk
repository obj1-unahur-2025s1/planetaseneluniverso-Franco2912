class Persona {
    var monedas = 20
    var edad

    method recursos() = monedas
    method esDestacado() = edad.between(18, 65) || monedas > 30

    method ganarRecursos(cantRecursos) {
        monedas += cantRecursos
    }
    method gastarRecursos(cantRecursos) {
        monedas -= cantRecursos
    }

    method cumplirAños(cantAños){
        edad += cantAños
    }

    method trabajarEnPlaneta(){}
}

class Productor inherits Persona {
    const planetaDondeVive
    const tecnicas = #{}
    method initialize(){
        tecnicas.add("cultivo")
    }

    override method recursos() = super() * tecnicas.size()
    override method esDestacado() = super() || tecnicas.size() > 5

    method realizarTecnica(unaTecnica, unTiempo){
        if(tecnicas.contains(unaTecnica)) {
            self.ganarRecursos(unTiempo * 3)
        } else {
            self.recursos() - 1
        }
    }

    method aprenderTecnica(nombre) {
        tecnicas.add(nombre)
    }

    method trabajarEnPlaneta(unTiempo, unPlaneta) {
        if (planetaDondeVive == unPlaneta && tecnicas.size() > 0) {
            self.realizarTecnica(tecnicas.last(), unTiempo)
        }
    }
}

class Constructor inherits Persona {
    var cantConstrucciones
    const region // "montaña", "costa", "llanura", "ciudad" (nueva región)
    const inteligencia

    override method recursos() = super() + 10 * cantConstrucciones
    override method esDestacado() = cantConstrucciones > 5

    method trabajarEnPlaneta(unTiempo, unPlaneta) {
        self.gastarRecursos(5)
        cantConstrucciones += 1

        const murallaC = new Muralla(longitud=unTiempo/2)
        const museoC = new Museo(superficie=unTiempo, indiceImportancia=1)

        if(region == "montaña") {           
            unPlaneta.construciones().add(murallaC)
        } else if(region == "costa") {
            unPlaneta.construciones().add(museoC)
        } else if(region == "llanura") {
            if(self.esDestacado()) {
                const nivel = (self.recursos() / 20).toInt().max(1).min(5)
                const museoC2 = new Museo(superficie=unTiempo, indiceImportancia=nivel)
                unPlaneta.construciones().add(museoC2)
            } else {
                unPlaneta.construciones().add(murallaC)
            }
        } else if(region == "ciudad") { // Nueva región
            if(inteligencia > 5) {
                unPlaneta.construciones().add(museoC)
            } else {
                unPlaneta.construciones().add(murallaC)
            }
        }
    }
    
}


class Muralla {
    const longitud

    method valor() = longitud * 10
}

class Museo {
    const superficie
    const indiceImportancia
    method initialize() {
        if(indiceImportancia < 1 || indiceImportancia > 5) {
            throw ("El índice de importancia debe estar entre 1 y 5.")
        }
    }

    method valor() = superficie * indiceImportancia
} 

class Planeta {
    const habitantes = #{}
    const property construciones = []

    method habitanteConMasRecursos() = habitantes.max({h => h.recursos()})
    method habitantesMasDestacados() = habitantes.filter({h => h.esDestacado()}).asSet()
    
    method delegacionDiplomatica() = self.habitantesMasDestacados() + #{self.habitanteConMasRecursos()}

    method siEsValioso() = construciones.sum({c => c.valor()}) > 100
}    