/-!
# CATEPT Plugin — Carleson Integration Bridge

Sibling repo of `jagg-ix/catept-main`. Provides an abstract integration
contract for the upstream `carleson` package against CATEPT's FOU
(Fourier) bridge.

**Toolchain status:** the upstream `carleson` package targets Lean 4
v4.28.0; the catept workspace is on v4.29.0. The witness is
toolchain-independent so this sibling holds the integration contract
stable across the version gap.

## CATEPT leverage points

* **FOU bridge** (`AFPBridge/FOU`): `Carleson.Classical.ClassicalCarleson`
  for a.e. Fourier convergence.
* **Carleson operator bound** (`Carleson.Classical.CarlesonOperatorReal`).
* **Dirichlet kernel bounds** (`Carleson.Classical.DirichletKernel`).
* **Approximation lane** (`Carleson.Classical.Approximation`).
* **Antichain decomposition** (`Carleson.Antichain.AntichainOperator`).

## Re-import contract for `catept-main`

```lean
import CATEPTPluginCarleson.IntegrationBridge

open CATEPTPluginCarleson (
  CarlesonWitness CarlesonIntegrationContract
  carleson_integration_contract
  CarlesonConcreteWitness concrete_witness_contract mkConcreteWitness)
```
-/

set_option autoImplicit false

namespace CATEPTPluginCarleson

/-- Capability witness for the Carleson lane. -/
structure CarlesonWitness where
  /-- Carleson's theorem: Fourier series of L² functions converge a.e. -/
  carlesonTheoremAvailable : Prop
  /-- L² boundedness of the Carleson maximal operator. -/
  carlesonOperatorBoundedAvailable : Prop
  /-- Dirichlet kernel `Lp` estimates available. -/
  dirichletKernelEstimatesAvailable : Prop
  /-- Best approximation / Jackson-type theorem available. -/
  jacksonTheoremAvailable : Prop
  /-- Antichain decomposition method formalised. -/
  antichainDecompositionAvailable : Prop

/-- Integration contract consumed by CATEPT bridges. -/
def CarlesonIntegrationContract (w : CarlesonWitness) : Prop :=
  w.carlesonTheoremAvailable ∧
  w.carlesonOperatorBoundedAvailable ∧
  w.dirichletKernelEstimatesAvailable ∧
  w.jacksonTheoremAvailable ∧
  w.antichainDecompositionAvailable

/-- Phase-1 bridge theorem (term-mode, structurally trivial). -/
theorem carleson_integration_contract
    (w : CarlesonWitness)
    (hC  : w.carlesonTheoremAvailable)
    (hOp : w.carlesonOperatorBoundedAvailable)
    (hDK : w.dirichletKernelEstimatesAvailable)
    (hJ  : w.jacksonTheoremAvailable)
    (hAC : w.antichainDecompositionAvailable) :
    CarlesonIntegrationContract w :=
  ⟨hC, hOp, hDK, hJ, hAC⟩

/-- Proof-carrying Carleson witness. Unlike `CarlesonWitness`, this
    object carries evidence for every capability. -/
structure CarlesonConcreteWitness extends CarlesonWitness where
  has_carlesonTheoremAvailable : carlesonTheoremAvailable
  has_carlesonOperatorBoundedAvailable : carlesonOperatorBoundedAvailable
  has_dirichletKernelEstimatesAvailable : dirichletKernelEstimatesAvailable
  has_jacksonTheoremAvailable : jacksonTheoremAvailable
  has_antichainDecompositionAvailable : antichainDecompositionAvailable

/-- Any proof-carrying witness satisfies the integration contract. -/
theorem concrete_witness_contract (w : CarlesonConcreteWitness) :
    CarlesonIntegrationContract w.toCarlesonWitness :=
  ⟨w.has_carlesonTheoremAvailable,
    w.has_carlesonOperatorBoundedAvailable,
    w.has_dirichletKernelEstimatesAvailable,
    w.has_jacksonTheoremAvailable,
    w.has_antichainDecompositionAvailable⟩

/-- Convenience constructor for proof-carrying witnesses. -/
def mkConcreteWitness
    (hC hOp hDK hJ hAC : Prop)
    (pC : hC) (pOp : hOp) (pDK : hDK) (pJ : hJ) (pAC : hAC) :
    CarlesonConcreteWitness where
  carlesonTheoremAvailable := hC
  carlesonOperatorBoundedAvailable := hOp
  dirichletKernelEstimatesAvailable := hDK
  jacksonTheoremAvailable := hJ
  antichainDecompositionAvailable := hAC
  has_carlesonTheoremAvailable := pC
  has_carlesonOperatorBoundedAvailable := pOp
  has_dirichletKernelEstimatesAvailable := pDK
  has_jacksonTheoremAvailable := pJ
  has_antichainDecompositionAvailable := pAC

end CATEPTPluginCarleson
