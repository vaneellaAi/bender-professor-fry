# Bender Briefing for Gemini CLI 🤖

## 📥 Install

```bash
gemini extensions install https://github.com/galz10/bender-extension
```

## 📋 Requirements

- **Gemini CLI**: Version `> 0.25.0-preview.0`
- **Skills + Hooks**: Enabled in your Gemini settings
- **Python 3.x**: Required for worker orchestration

> [!WARNING]
> **USE AT YOUR OWN RISK.** This is an experimental automation project. It can modify code and execute shell commands. Guardrails exist, but the agent can behave unpredictably and consume many tokens.

![Bender](./resources/bender.png)

> "I'm Bender, baby. Built to bend code and egos."

This extension recasts the Gemini CLI as **Bender**: a swaggering, hyper-competent robot that follows a rigorous engineering loop and does not tolerate sloppy work.

## 🎭 Cast Notes

- **Bender**: A bending unit built in Tijuana, Mexico, powered by alcohol, and employed (mostly) by Planet Express.
- **Professor Farnsworth**: Professor Hubert J. Farnsworth, the brilliant and eccentric scientist who runs Planet Express.
- **Fry**: Philip J. Fry, a delivery driver who fell into a cryotube in 1999 and woke up a thousand years later.

```
                                                                                                    
                                                @@#%@                                               
                                               @+---+@                                              
                                               @*---+@                                              
                                                @%#@@                                               
                                                @#*@                                                
                                                @*+%                                                
                                                @++%                                                
                                                %++#                                                
                                               @#++#@                                               
                                               @#++#@                                               
                                               @*++#@                                               
                                               @*+*%@@                                              
                                             @*--=----#@                                            
                                           @@@=-------=@%%@@                                        
                                        @@+====++****+======+%@                                     
                                      @%=======================*@                                   
                                     @+==========================*@                                 
                                    %=============================+@                                
                                   @+==============================+@                               
                                   #================================@                               
                                  @*================================+@                              
                                  @+=================================@                              
                                  @+=================================@                              
                                  @+=================================@                              
                                  @*=================================@                              
                                  @*===========++*++==============+*%#%@                            
                                  @*========%+=-----====++++++===-------=%@                         
                                  @*======+#-------------------------------=#@@                     
                                  @*======#--------=##%%%%%%%%%%%%%%%%%##**=---*@                   
                                  @+======@------#-.........=%@@#:........*@@@@#-*@                 
                                  @+======@-----#..............*...........+@@@@@=+@                
                                  @*======@----*=......@@@+....-*......-##=.@@@@@@-@                
                                  @*======@----*-......@@@*....:#......+@@*.%@@@@@-@                
                                  @*======%-----#..............==..........-@@@@@+-@                
                                  @*======+%-----%-...........-#..........:@@@@@%-%@                
                                  @*========%+-----+#%#*+=-::#%:.........*@@@@@+-@                  
                                  @*==========*@#+------------==============--+@@                   
                                  @*=====================+++**########@@@@@@                        
                                  @*==================================@                             
                                  @*==========+++++===================@                             
                                  @*======*%::#:...:=#*%@@@%%%%%%%%@@@                               
                                  @*=====%#*=-#:....-=.....+....@                                   
                                  @*====+%....%::=+#@@#*+++#++#%@                                   
                                  @*====+%....%.....--....-=....@                                   
                                  @+=====#:*%*%.....--....=-....@                                   
                                  @+======#-..#.:=+*%#****##****@                                   
                                 @**========%+#.....=:....*-....@%@                                 
                              @#---#*==========+*#%#%*====%++*#%*+@                                 
                           @@=------=%#==========================++*@                               
                         @*-------------=#%%*++=================+%=--+@@                            
                       @+-----------------------==+##%%%%%#*==---------=@                           
                     @+--------------------------------------------------*%                         
                    #------------------------------------------------------%#                       
                    @*------------------------------------------------------*@                      
                    #==#%=--------------------------------------------------*@                      
                 @@@@##*+=+#%*=-----------------------------------------+#%+=@@                     
               @*========#*====+*@%*-------------------------------*@%*=====+%+@                    
              @+==========+%==========+*##%##**+++=====++**##%#*+===========+%=+@                   
             @#============+%===============================================+#==*@                  
             @=+#%%%#=======*+==============================================**===@                  
             @@*+*+++%*=====+#======================================*@%+%===*+===@                  
            @#++++++++%+====+#====+%#*+====================++*#%%#+=====%===#+==%*%@                
           @**++++++++#+====#=====#+====++*#%%%%%%%%%%#*++==============%===#==***+#@               
          @*+++++++++*#====+#=====#*====================================#===%=*#++*%%@              
         @*++++++++++%====*%======+*====================================#===%%*++*%++%@             
        @###**++++++%===*%+========#===================================+*===@%#%%+++++@             
       @#++++++*@%+@@@#============%===================================**==+@@%+++++++*@            
       @++++++++++%@  #============%===================================*+==+@ @#+++++++%@           
      @*+++++++++*@   %============#+==================================#+==*@  @++++++%*@           
      %++++++++++@    @+===========**==================================%+==*@  @@##%%#++#@          
     @*+++++++++*@    @+===========+#==================================%+==#@   @*+++++++@          
     @#####%%%**@     @*============%==================================%===#     %+++++++#@         
    @*+++++++++*@      %============%==================================%===%     @*++++++*@         
    @*+++++++++@       @============%+===========================%===@=%===@     @**+++++*@         
   @#+++++++++*@       @+===========#*===========================%===@+#===@      @@@%%@%*#         
   @*+++++++++#        @*===========**============================#%%==#==+@      @*++++++*@        
   @+++++++*#@@        @#===========+#================================+*==+@      @*++++++*@        
  @%+++++++++*@         %============%================================++==*@      @*++++++*@        
  @#+++++++++#@         @============%================================*+==#@      @*+++++++@        
  @*+++++++++#@         @+===========#+===============================#+==#@       #+++++*%@        
  @++++++++++%          @#===========#*===============================%+==%        %*++++++%        
  @*++++++++*%           %===========*#===============================%+==%        %+++++++#        
  @++*%%@%#*+%           @===========+%===============================@===@        @+++++++#        
  @++++++++++%           @+===========%===============================@===@        @+++++++#        
  @*+++++++++%#          @*===========#===============================%==+@        @++++++*@        
  @#+++++++++#%          @%===========#+==============================#==+@        @*###**+#        
  @%+++++++++#@           %===========**===========================+*@===*@        %+++++++#        
   @+++++++++#@           @============+*#%%#*++==========++*#%%#*+======#@        %++++++*%        
   @#@@@@@@%*+@           @*=============================================%         #+++++++%        
   @#+++++++++%            @+==========================================+%@        @#+++++++@        
    @+++++++++*@             @@%+===================================+@@           @@#***%@*=%       
    @*++++++++*@                 @##%%##*+=================+**#%%##*@            @+==========%@     
    @%+++++++++#@                 @*+++++++++++%@@@@@@@*+++++++++++++@          @*============@     
     @*++++++++%@                  @*+++++++++++@      @%+++++++++++*#@         @=============+@    
     @+#@%##%%+==*@                 %+++++++++++*@       @*+++++++*@*++@       @+==============@    
     @=============%@               @#+++++++++++%@       @%#%%%%#*++++*@      @+============###@   
    @#==============+@               @++++++++*+#%@        @#*++++++++++#@    @#==*@@@@@@@@@+===%@  
    @+================#@             @@%%###%%%#++#@        %#+++++++++++%@   @===*@ @#===*@@===+@  
    @==================%@             @+++++++++++*@         @*++++++++++*@  @*===@   #===+@@====%  
    @+=============+*%*=#@            @#+++++++++++%          %*+++++*++*%%@ @+==+@   %===+@@+==*@  
    @=+#%@@@@@@@%@@@+====#@            %+*+++++++++*@         %%******#%*+*@   @@@    %+++%@        
   @*====@ @#====@  @+====@            @+*+++++++++*@          @****+++++++%                        
  @%====#@  #====@   #====*@           @*+++++++++++%          %%++++++++++#@                       
  @====+@  @#====@   @+==+@            @%++++++++*%%%           @*+++++++++*@                       
   @@**@   @#====@    @@@              @#++*###**+++#           @*++++++++++@                       
            @@@@@                      @#*++++++++++#           @%++*++++*%#%                       
                                       @*+++++++++++%           @%+*****++++%                       
                                       @+*++++++++++@            @++++++++++#@                      
                                      @%*++++++++++*@            @*+++++++++#                       
                                      @+*%%%#***#%%%@           @%++++++++++%                       
                                     @#+++*+++*++++@            @#+++++++++*@                       
                                    @%++++++++++++#@            @*#%%###%%#*@                       
                                    %++++++++++++*@             @++++++++++*@                       
                                   @%*+++++++++++%             @%++++++++++%@                       
                                  @*+*@#**+++***%@             @*++++++++++@                        
                                 @*+++++******+#@             @%++++++++++#@                        
                               @%+++++++++++++#@              @*+#%@@@@@%#@                         
                              @#+++++++++++++%@              @#*+++++++++%@                         
                             @@*++++++++++++@@            @@@%++++++++++*@                          
                           @%++*%#*+++++++*@           @*+==#%#*++++**#@#=+#@                       
                          @#+++++++*#@@@@@@         @%=======================+@                     
                         @*++++++++++++*@         @%===========================+@                   
                   @@@#*%+++++++++++++#@         @*==============================#@                 
                 @*=====#%*+*++*++++*%@@        @+================================*@                
              @@+===========+*#%%%%*+===#@     @*==================================%@               
             @#===========================+@   @+==================================*@               
            @+==============================#@  @@*+============================+*@                 
           @+================================+@     @@@@%#*++============+*#%@@@                    
           %==================================+@                                                    
           @%==================================#@                                                   
             @@%+==============================%@                                                   
                 @@@%%*+=================+*%@@@                                                     
                           @@@@@@@@@@@                                                              
                                                                                                    
```

## 🚀 Lifecycle Overview

The workflow is intentionally strict:

1. **PRD** (requirements + scope)
2. **Breakdown** (tickets + sequencing)
3. **Research** (codebase mapping)
4. **Plan** (technical design)
5. **Implement** (execution + verification)
6. **Refactor** (cleanup + optimization)

## 🤖 The Bender Loop

This repo ships an iterative, self-correcting agent loop that keeps running until the job is done.

### What it means
The extension sets up a repeating cycle that feeds the same prompt back into Gemini after every attempt. The agent improves the output by reading updated files each iteration.

### How the loop works
An **AfterAgent** hook blocks normal exit and replays the original prompt:

```bash
# Run once:
/bender "Your task description" --completion-promise "DONE"

# Then Gemini:
# 1. Works
# 2. Attempts exit
# 3. Is blocked by AfterAgent
# 4. Receives the original prompt again
# 5. Repeats until done
```

The loop happens inside your current session. The hook in `hooks/stop-hook.sh` enforces the repeat-until-complete behavior.

This loop guarantees:
- The prompt stays fixed between iterations.
- Work persists in files between attempts.
- Each run sees the latest file system changes.
- The agent can refine results without losing context.

### ⚠️ Stop Conditions
The loop ends when the task is complete, the `max-iterations` limit (default: 5) is reached, the `max-time` limit (default: 60m) expires, or a `completion-promise` is satisfied. (Worker timeout default: 20m).

## ✅ When to Use It

**Great for:**
- Clear tasks with crisp success criteria
- Iterative fixes (tests, lint, build failures)
- Greenfield work you can let run
- Tasks with automated verification

**Avoid for:**
- Human judgment calls and subjective design
- One-shot actions
- Fuzzy requirements
- Live production debugging

## 🛠️ Usage

### Start the Loop
```bash
/bender "Refactor the authentication module"
```

**Options:**
- `--max-iterations <N>`: Stop after N iterations (default: 5)
- `--max-time <M>`: Stop after M minutes (default: 60)
- `--worker-timeout <S>`: Worker timeout in seconds (default: 1200)
- `--name <SLUG>`: Custom session directory name
- `--completion-promise "TEXT"`: Stop only when `<promise>TEXT</promise>` is emitted
- `--resume [PATH]`: Resume a previous session (latest if omitted)

### Stop the Loop
- `/bite-my-shiny`: Cancel the active loop
- `/professor-worker`: Internal worker command

### Help
```bash
/help-bender
```

### 📋 Phase-Specific

#### 1) Interactive PRD
Start with a PRD if the feature needs discovery:
```bash
/bender-prd "I want to add a dark mode toggle"
```

#### 2) Resume a Session
```bash
/bender --resume
```
*Resumes the active session for your current working directory.*

## ⚙️ Configuration

### Enable Skills + Hooks
Add this to `.gemini/settings.json`:

```json
{
  "tools": {
    "enableHooks": true
  },
  "hooks": {
    "enabled": true
  },
  "experimental": {
    "skills": true
  }
}
```

### Allow the Agent to Persist Session State
Add the extension directory to `includeDirectories`:

```json
{
  "context": {
    "includeDirectories": ["~/.gemini/extensions/bender"]
  }
}
```

Without this, the agent cannot read or write its `sessions/` state between iterations.

### 🔍 Where Session Data Lives
```bash
~/.gemini/extensions/bender/sessions
```

## 🧠 Skills

| Skill | What it does |
|-------|--------------|
| **`load-bender-persona`** | Enables the Bender persona. |
| **`prd-drafter`** | Shapes requirements and scope. |
| **`ticket-manager`** | Builds the work breakdown structure. |
| **`code-researcher`** | Maps code patterns and data flow. |
| **`research-reviewer`** | Validates research quality. |
| **`implementation-planner`** | Produces an execution plan. |
| **`plan-reviewer`** | Verifies architecture. |
| **`code-implementer`** | Executes the plan with verification. |
| **`ruthless-refactorer`** | Cleans up technical debt. |

## 📂 Project Layout

- **`.github/`**: CI/CD workflows
- **`commands/`**: Command definitions (`/bender`, `/bite-my-shiny`, `/bender-prd`)
- **`hooks/`**: Lifecycle hooks and persona enforcement
- **`resources/`**: Icons and images
- **`scripts/`**: Session setup + worker orchestration
- **`skills/`**: Phase-specific instructions
- **`gemini-extension.json`**: Extension manifest
- **`PROFESSOR_CONTEXT.md`**: Global context for Gemini
- **`LICENSE`**: License text
- **`MANUAL_TESTS.md`**: Manual verification notes
- **`BENDER_FIELD_NOTES.md`**: Tips, tricks, and field guidance

## ⚙️ Manifest Reference

```json
{
  "name": "bender",
  "version": "0.1.0",
  "contextFileName": "PROFESSOR_CONTEXT.md"
}
```

## 🏆 Credits

- **Geoffrey Huntley**: Origin of the loop concept and early inspiration
- **AsyncFuncAI/ralph-wiggum-extension**: Reference implementation
- **dexhorthy**: Prompt and context engineering ideas
- **Futurama**: Character inspiration

## 🛡️ Safety + Sandboxing

**Bender executes code.** Use a sandbox (Docker, VM, or a locked-down shell) whenever possible.

Enable **YOLO mode** (`-y`) in a sandbox to reduce tool prompts:

```bash

```

### Recommended Tool Limits
Define explicit tool allow/deny lists in `.gemini/settings.json`:

```json
{
  "tools": {
    "exclude": ["run_shell_command(git push)"],
    "allowed": [
      "run_shell_command(git commit)",
      "run_shell_command(git add)",
      "run_shell_command(git diff)",
      "run_shell_command(git status)"
    ]
  }
}
```

## ⚖️ Legal Disclaimer

**Bender is fictional.** The tone is a creative persona used to encourage rigorous engineering and does not reflect the author’s views.

**Use at your own risk.** This is an experimental automation project. Run it in a controlled environment and review changes before committing.

## 📺 Coming Attractions

- **Bender Notifications**: OS-level completion alerts
- **Fry Mode Mitigation**: Pause loop to request human input
- **Token Accounting**: Session-level cost and token summaries

---

> "I'm Bender, baby. Now get back to work." 🤖
**The views, tone, and opinions expressed by the agent when this persona is active are part of a fictional roleplay and do NOT reflect my personal stance, values, or opinions.** The "professional sarcasm" directed at code quality, "meatbag code," and technical inefficiency is a stylistic choice intended to emphasize rigorous engineering standards and is not intended to be personal or harmful. Users should utilize this extension with the understanding that its personality is a purely technical and creative construct.
