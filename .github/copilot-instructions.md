# Copilot Instructions for FixHostTimeScale SourcePawn Plugin

## Repository Overview

This repository contains a SourcePawn plugin for SourceMod that fixes the `host_timescale` ConVar bug which can crash Source engine game servers. The plugin prevents `host_timescale` from being set to values less than 1, which causes server instability.

**Key Files:**
- `addons/sourcemod/scripting/FixHostTimeScale.sp` - Main plugin source code
- `.github/workflows/ci.yml` - CI/CD pipeline for automated building and releases (native GitHub Actions, no external build tool)

## Technical Environment

- **Language**: SourcePawn (.sp files)
- **Platform**: SourceMod 1.12.x
- **Build System**: Native GitHub Actions using `rumblefrog/setup-sp` to install the SourcePawn compiler
- **Compiler**: SourcePawn compiler (spcomp) - installed directly in CI via `rumblefrog/setup-sp`
- **Target**: Source engine game servers (CS:GO, CS2, TF2, etc.)

## Build System (GitHub Actions)

### Build Configuration
The `.github/workflows/ci.yml` file defines:
- SourceMod/spcomp version (1.12.x) via `rumblefrog/setup-sp`
- Compilation of `addons/sourcemod/scripting/FixHostTimeScale.sp` into `addons/sourcemod/plugins/FixHostTimeScale.smx`
- Packaging and release steps

### Building the Plugin
```bash
# Locally, install a SourcePawn compiler (spcomp) matching SourceMod 1.12.x
# Then compile directly:
spcomp -i addons/sourcemod/scripting/include -o addons/sourcemod/plugins/FixHostTimeScale.smx addons/sourcemod/scripting/FixHostTimeScale.sp
```

### CI/CD Pipeline
The GitHub Actions workflow:
1. Installs spcomp via `rumblefrog/setup-sp` and compiles the plugin directly
2. Creates packages for distribution
3. Automatically creates releases with compiled `.smx` files
4. Supports both tag-based and latest releases

## Code Style & Standards

### Required Pragma Directives
```sourcepawn
#pragma semicolon 1
#pragma newdecls required
```

### Naming Conventions
- **Global variables**: Use `g_` prefix (e.g., `g_ConVar_HostTimeScale`)
- **Functions**: PascalCase (e.g., `OnPluginStart`)
- **Local variables**: camelCase (e.g., `newValue`, `oldValue`)
- **Constants**: UPPER_CASE or PascalCase

### Indentation and Formatting
- Use tabs for indentation (equivalent to 4 spaces)
- Remove trailing whitespace
- Use descriptive variable and function names
- Consistent brace placement

## Plugin Development Patterns

### Essential Plugin Structure
```sourcepawn
#pragma semicolon 1
#include <sourcemod>
#include <sdktools>  // Include additional libraries as needed
#pragma newdecls required

// Global variables with g_ prefix
ConVar g_ConVar_Example;

// Plugin information (always required)
public Plugin myinfo = {
    name = "Plugin Name",
    author = "Author",
    description = "Brief description",
    version = "1.0",
    url = ""
};

// Initialization
public void OnPluginStart() {
    // Plugin setup code
}

// Cleanup (if needed)
public void OnPluginEnd() {
    // Cleanup code
}
```

### ConVar Handling
- Use `FindConVar()` to get existing ConVars
- Use `AddChangeHook()` for monitoring changes
- Always validate ConVar values in change hooks
- Use `.IntValue`, `.FloatValue`, `.BoolValue` properties

### Error Prevention
- Validate all ConVar values before use
- Handle edge cases (like values < 1 for timescale)
- Provide user feedback for invalid operations
- Use multiple warning messages for critical issues

## Best Practices for This Repository

### Memory Management
- ConVars are managed automatically by SourceMod
- No manual cleanup needed for ConVar hooks
- Use `delete` for handles when necessary (not applicable to this simple plugin)

### Performance Considerations
- ConVar hooks are called frequently - keep them lightweight
- Avoid complex operations in frequently called callbacks
- Cache expensive computations when possible

### User Communication
- Use `PrintToChatAll()` for server-wide messages
- Repeat critical warnings multiple times (as shown in the current code)
- Keep messages clear and actionable

### Version Control
- Use semantic versioning in plugin info
- Keep commits focused and descriptive
- Tag releases correspond to plugin version numbers

## Testing and Validation

### Local Testing
1. Build the plugin with spcomp
2. Copy `.smx` file to SourceMod plugins directory
3. Test on a development server
4. Verify ConVar behavior with various values

### Server Integration
- Install in `addons/sourcemod/plugins/`
- Monitor server logs for errors
- Test with actual players to verify functionality
- Check for conflicts with other plugins

## Debugging

### Common Issues
- **Build failures**: Check the GitHub Actions workflow configuration and SourceMod version
- **Plugin not loading**: Verify SourceMod installation and plugin compatibility
- **ConVar not found**: Ensure the game supports the ConVar
- **Hook not working**: Check if ConVar exists and is accessible

### Debugging Tools
- Use `LogMessage()` for debug output
- Check SourceMod error logs
- Use `sm plugins list` to verify plugin status
- Monitor server console for errors

## Repository-Specific Notes

### Current Implementation
The plugin specifically:
- Monitors `host_timescale` ConVar changes
- Prevents values less than 1 (which cause crashes)
- Resets to 1 on map end
- Warns players about dangerous values

### Modification Guidelines
- Keep the core functionality simple and focused
- Any changes should maintain the crash prevention goal
- Consider adding configuration options for warning messages
- Test thoroughly on different Source engine games

### Adding Features
If extending the plugin:
- Add configuration file support in `addons/sourcemod/configs/`
- Use translation files for multi-language support
- Implement proper command registration for admin features
- Follow the existing code style and patterns

## Common SourcePawn Patterns

### Include Hierarchy
```sourcepawn
#include <sourcemod>     // Core SourceMod functionality
#include <sdktools>      // Extended SDK tools
#include <cstrike>       // CS-specific functions (if needed)
#include <tf2>           // TF2-specific functions (if needed)
```

### Event Handling
```sourcepawn
// Hook game events
HookEvent("player_spawn", Event_PlayerSpawn);

public void Event_PlayerSpawn(Event event, const char[] name, bool dontBroadcast) {
    int client = GetClientOfUserId(event.GetInt("userid"));
    // Handle event
}
```

### Command Registration
```sourcepawn
public void OnPluginStart() {
    RegAdminCmd("sm_command", Command_Example, ADMFLAG_GENERIC, "Description");
}

public Action Command_Example(int client, int args) {
    // Command logic
    return Plugin_Handled;
}
```

## File Organization

### Directory Structure
```
addons/sourcemod/
├── scripting/           # Source files (.sp)
│   ├── FixHostTimeScale.sp
│   └── include/         # Custom includes (.inc)
├── plugins/             # Compiled plugins (.smx)
├── configs/             # Configuration files
├── translations/        # Language files (.txt)
└── gamedata/           # Game signatures (.txt)
```

### Compilation Output
- Source files: `.sp` → Compiled plugins: `.smx`
- GitHub Actions CI handles compilation via `spcomp` installed by `rumblefrog/setup-sp`
- Output directory: `addons/sourcemod/plugins/`

## Security Considerations

### Input Validation
- Always validate user input in commands
- Sanitize chat messages and file paths
- Check array bounds and handle edge cases
- Validate ConVar values before applying

### Safe Coding Practices
- Use `const char[]` for read-only string parameters
- Prefer `Format()` over `strcopy()` for string building
- Always check return values of API calls
- Handle null/invalid clients properly

## Performance Optimization

### Efficient Patterns
```sourcepawn
// Cache frequently accessed ConVars
ConVar g_CachedConVar;

// Use timers sparingly
CreateTimer(1.0, Timer_Example, _, TIMER_REPEAT);

// Minimize string operations in loops
// Pre-calculate values when possible
```

### Memory-Conscious Development
- This simple plugin doesn't use dynamic memory
- For complex plugins: use `delete` for handles
- Avoid memory leaks with ArrayList/StringMap
- Clean up timers and hooks in OnPluginEnd()

## Integration with Development Tools

### GitHub Codespaces/VS Code
- Install SourcePawn syntax highlighting extensions
- Use the integrated terminal to run `spcomp` directly
- Leverage GitHub Actions for automated testing

### Continuous Integration
- All changes trigger automatic builds
- Failed builds block merges
- Releases are automatically generated from tags
- Artifacts are preserved for download

### Local Development Setup
1. Install a SourcePawn compiler (spcomp) matching SourceMod 1.12.x
2. Clone repository
3. Run `spcomp` against `addons/sourcemod/scripting/FixHostTimeScale.sp` for compilation
4. Test compiled plugins on development server

## Troubleshooting Common Issues

### Build Problems
- **"spcomp not found"**: Ensure `rumblefrog/setup-sp` step ran successfully in CI, or install spcomp locally
- **"spcomp failed"**: Check SourceMod version compatibility
- **"Include not found"**: Verify include paths in the workflow

### Runtime Issues
- **Plugin not loading**: Check SourceMod version and dependencies
- **ConVar not found**: Verify game compatibility and ConVar existence
- **Hooks not firing**: Ensure proper event/ConVar names

### SourceMod-Specific Debugging
```sourcepawn
// Debug logging
LogMessage("Debug: Variable value = %d", someValue);

// Console output
PrintToServer("Server message");
PrintToChat(client, "Client message");
PrintToChatAll("Global message");
```

This plugin serves as a good example of focused, single-purpose SourcePawn development following SourceMod best practices.