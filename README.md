# Api
```
@checked function Platform.GetPlatform(): (Enum.Platform, number) -- returns Platform and Architecture
```
# Example
```luau
const ReplicatedFirst = game:GetService("ReplicatedFirst")
const Modules = ReplicatedFirst.Modules
const Platform = require(Modules.Platform)

const UserPlatform, Architecture = Platform.GetPlatform()
print(`{UserPlatform.Name} x{Architecture}`)
```
