import Lake
open Lake DSL

package «catept-plugin-carleson» where
  leanOptions := #[]

require mathlib from git
  "https://github.com/leanprover-community/mathlib4.git" @ "8a178386ffc0f5fef0b77738bb5449d50efeea95"

@[default_target]
lean_lib «CATEPTPluginCarleson» where
  roots := #[`CATEPTPluginCarleson.IntegrationBridge]
