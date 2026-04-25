# catept-plugin-carleson

Sibling repo of [`jagg-ix/catept-main`](https://github.com/jagg-ix/catept-main).
12th plugin extracted under [Target 5](https://github.com/jagg-ix/catept-main/blob/main/docs/architecture/targets/target-4-plan.md)
(Phase 2 / scale-out, T5 follow-on).

## What this provides

Abstract integration contract for the upstream `carleson` package
against CATEPT's FOU (Fourier) bridge. Defines a five-field
`CarlesonWitness` capability bundle, a derived integration contract,
and a proof-carrying `CarlesonConcreteWitness` for downstream bridges
that prefer a single concrete object over loose assumptions.

| Theorem | What it asserts |
|---|---|
| `carleson_integration_contract` | `CarlesonWitness → CarlesonIntegrationContract w` (term-mode) |
| `concrete_witness_contract` | Any `CarlesonConcreteWitness` satisfies the integration contract |

Both depend only on the kernel axioms `propext`, `Classical.choice`,
`Quot.sound` (or no axioms — purely structural). No `sorry`. Verified
via `#print axioms`.

## Dependencies

| Pin | Version |
|---|---|
| Lean toolchain | `leanprover/lean4:v4.29.0` |
| Mathlib | `8a178386ffc0f5fef0b77738bb5449d50efeea95` |

No upstream `carleson` pin yet — the witness is interface-level
abstract. Phase-2 work item: pin the carleson package once it lands a
v4.29-compatible release, then replace the abstract `*Available` Prop
fields with direct imports of `Carleson.Classical.*` and
`Carleson.Antichain.*`.

## Re-import contract

```lean
require «catept-plugin-carleson» from git
  "https://github.com/jagg-ix/catept-plugin-carleson.git" @ "<sha>"
```

```lean
import CATEPTPluginCarleson.IntegrationBridge

open CATEPTPluginCarleson (
  CarlesonWitness CarlesonIntegrationContract
  carleson_integration_contract
  CarlesonConcreteWitness concrete_witness_contract mkConcreteWitness)
```

## Build locally

```bash
lake exe cache get
lake build
```

## License

MIT, matching `catept-main`.
