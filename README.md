# oh-my-korean

### 뜻은 정확하게, 글의 모양과 말투는 그대로.

한국어 원문을 최소한으로 교정하는 **`natural-korean`** 스킬과 **원샷 프롬프트**입니다.

`단단하다`, `선명하다`, `구조`, `설계` 같은 말이 구체적인 뜻을 가릴 때, 제공된 근거 안에서 정확하게 풀어 씁니다. 맞춤법과 번역투도 점검합니다. 단어를 무조건 지우거나 다른 추상어로 바꾸지 않습니다.

**Claude Code · Codex** / **Windows · macOS · WSL · Linux**

[설치 없이 바로 쓰기](#설치-없이-원샷-프롬프트-쓰기) · [스킬 등록하기](#스킬-등록하기) · [사용 예시](#사용-예시) · [표현별 교정표](docs/expression-change-table.md) · [등록 상세 안내](docs/installation.md)

---

## 어떤 도구인가요?

AI에게 줄 **한국어 교정 지침**입니다. 원샷 프롬프트는 매번 붙여 넣고, 스킬은 등록한 뒤 이름으로 불러옵니다. 두 방식의 판단 원칙은 같습니다.

| 선택 | 원샷 프롬프트 | natural-korean 스킬 |
| --- | --- | --- |
| 이런 경우에 | 설치 없이 지금 한 번 쓰고 싶을 때 | Claude Code·Codex에서 반복해서 쓸 때 |
| 준비 | [프롬프트 전체](one-shot-prompt.txt)를 복사 | 아래 설치 명령 실행 |
| 사용 | 프롬프트 끝에 원문 붙여 넣기 | 스킬을 호출하고 원문 보내기 |
| 기본 결과 | 원문 형식의 교정문만 | 원문 형식의 교정문만 |

```text
                +----------------------+
                | Your Korean original |
                +-----------+----------+
                            |
              +-------------+-------------+
              |                           |
     +--------v---------+       +---------v--------+
     | Paste the prompt |       | Call the skill   |
     +--------+---------+       +---------+--------+
              |                           |
              +-------------+-------------+
                            |
                  +---------v---------+
                  | Same editing rules|
                  +---------+---------+
                            |
                  +---------v---------+
                  | Minimal correction|
                  +-------------------+
```

### 어떻게 달라지나요?

아래는 **교정 기준을 설명하는 예시**입니다. 실제 모델 실행 결과가 아니며, 영어를 근거로 한 교정은 해당 영어 원문이 실제 입력에 있을 때만 적용할 수 있습니다.

| 한국어 원문 | 제공된 근거 | 기대하는 처리 |
| --- | --- | --- |
| 이 주장은 단단하다. | `This argument is logically consistent.` | 이 주장은 논리적으로 일관된다. |
| 이 주장은 단단하다. | `This claim is well supported by evidence.` | 이 주장은 충분한 근거로 뒷받침된다. |
| 이 주장은 단단하다. | 뜻을 특정할 근거 없음 | 그대로 유지 |
| 사진 속 글자가 선명하다. | 정확한 시각 표현 | 그대로 유지 |
| React 와 연결합니다. | 조사 띄어쓰기 오류 | React와 연결합니다. |

같은 `단단하다`라도 **논리에 모순이 없는지, 근거가 충분한지**에 따라 다르게 표현합니다. 어떤 뜻인지 알 수 없으면 추측하지 않습니다. 대응 영어가 있어도 자연스러운 한국어와 의도적인 비유는 유지합니다.

## 설치 없이 원샷 프롬프트 쓰기

1. [one-shot-prompt.txt](one-shot-prompt.txt)를 엽니다. GitHub의 **Raw** 또는 원본 파일 보기에서 전체 내용을 복사합니다.
2. 사용하는 AI 채팅에 **프롬프트 전체**를 붙여 넣습니다.
3. 프롬프트 끝에 `[교정할 한국어 원문]`이라고 적고 다음 줄에 자신의 글을 붙여 넣어 전송합니다.

대응하는 영어 원문이나 추가 참고 사항이 있으면 한국어 원문 앞에 항목별로 적습니다. 아래는 프롬프트 뒤에 붙이는 예시입니다.

```text
[추가 참고 사항]
원문의 존댓말과 목록을 유지해 주세요.

[교정할 한국어 원문]
- React 와 연결합니다.
- 설정이 저장되어졌습니다.
```

기대 출력은 다음과 같습니다.

```text
- React와 연결합니다.
- 설정이 저장됐습니다.
```

외부 파일이나 별도 프로그램은 필요하지 않습니다. 실제 교정 결과는 사용하는 AI 모델과 입력 문맥에 따라 달라집니다.

## 스킬 등록하기

여기서 **등록**은 Claude Code나 Codex가 읽는 사용자 폴더에 스킬 파일을 복사하는 것입니다. 스크립트가 AI 프로그램 자체를 설치하거나 로그인해 주지는 않습니다.

사용할 **Claude Code 또는 Codex**와 **Git**을 준비한 뒤, AI 도구를 사용할 계정으로 터미널을 열어 실행하세요. 기본값은 두 도구에 모두 등록하는 것입니다.

### Windows

PowerShell에서 순서대로 실행합니다.

```powershell
git clone https://github.com/8luerose/oh-my-korean.git
Set-Location .\oh-my-korean
powershell -NoProfile -ExecutionPolicy Bypass -File .\install.ps1
```

`-ExecutionPolicy Bypass`는 이 명령으로 시작하는 PowerShell 프로세스에만 적용됩니다.

### macOS · WSL · Linux

터미널에서 순서대로 실행합니다. WSL에서는 사용할 Ubuntu 등 배포판의 터미널을 먼저 여세요.

```bash
git clone https://github.com/8luerose/oh-my-korean.git
cd oh-my-korean
bash install.sh
```

macOS의 기본 셸이 zsh여도 위 명령을 그대로 사용할 수 있습니다. Ubuntu와 Red Hat 계열의 Linux에서 사용하는 Bash용 설치 파일을 제공합니다. Windows에서 Git Bash를 쓰고 있다면 PowerShell을 열고 Windows 설치 명령을 실행하세요.

Git이 없다면 GitHub의 **Code → Download ZIP**으로 내려받아 압축을 풀고, `install.sh` 또는 `install.ps1`이 있는 폴더에서 해당 설치 명령을 실행해도 됩니다.

### 한 도구만 쓰는 경우

| 대상 | macOS·WSL·Linux | Windows PowerShell |
| --- | --- | --- |
| Claude Code만 | `bash install.sh --agent claude` | `powershell -NoProfile -ExecutionPolicy Bypass -File .\install.ps1 -Agent claude` |
| Codex만 | `bash install.sh --agent codex` | `powershell -NoProfile -ExecutionPolicy Bypass -File .\install.ps1 -Agent codex` |

설치 후 스킬이 보이지 않으면 같은 환경에서 새 세션을 열거나 앱을 다시 시작하세요. **Windows와 WSL은 서로 다른 환경**이므로 두 곳에서 모두 사용하려면 각 환경에 한 번씩 등록합니다.

### 어떤 파일이 설치되나요?

```text
skills/natural-korean/
|-- SKILL.md
`-- references/
    `-- rules.json
          |
          v
  install.sh / install.ps1
          |
          +-- Claude Code --> ~/.claude/skills/natural-korean/
          |
          `-- Codex -------> ~/.agents/skills/natural-korean/
```

**두 파일이 모두 필요합니다.** 설치할 파일과 기존 파일의 내용이 같으면 건너뛰고, 다르면 기존 파일을 `파일명.backup.*`로 보관한 뒤 교체합니다. 설치 위치는 각 도구의 사용자 스킬 경로를 따릅니다. [Claude Code 공식 문서](https://code.claude.com/docs/en/skills), [Codex 공식 문서](https://learn.chatgpt.com/docs/build-skills)

[Windows 경로, 수동 등록, 사용자 지정 경로, 복구 방법 →](docs/installation.md)

## 사용 예시

**각 AI 도구를 실행한 뒤 아래 예시를 채팅 입력창에 넣습니다.**

### Claude Code

```text
/natural-korean 아래 원문을 교정해 주세요.

- React 와 연결합니다.
- 설정이 저장되어졌습니다.
```

### Codex CLI·IDE

```text
$natural-korean 아래 원문을 교정해 주세요.

- React 와 연결합니다.
- 설정이 저장되어졌습니다.
```

Claude Code는 `/스킬이름`으로 호출합니다. Codex CLI·IDE에서는 `$`로 스킬을 선택하거나 `/skills`에서 찾습니다. 데스크톱 앱에서는 해당 앱의 스킬 선택 목록에서 `natural-korean`을 선택하세요. [Claude Code 호출 안내](https://code.claude.com/docs/en/skills), [Codex 스킬 사용 안내](https://learn.chatgpt.com/docs/build-skills)

수정 이유도 필요하면 `교정문을 먼저 보여 주고, 수정 이유를 별도로 설명해 주세요`라고 덧붙이세요. 요청이 없으면 설명·요약·후속 제안을 붙이지 않습니다.

## 기대 효과와 현재 확인된 범위

**교정 지침과 재사용할 수 있는 파일을 만들었습니다. 실제 교정 효과는 아직 검증하지 않았습니다.**

| 원하는 결과 | 지침에 반영한 내용 | 현재 확인 수준 |
| --- | --- | --- |
| 포괄적인 단어에 묻힌 뜻 구별 | 제공된 영어·한국어 문맥으로 판단하고, 근거가 없으면 유지 | 지침·설계 예시 검토 완료, 실제 효과 미측정 |
| 원문의 형식·사실·말투 유지 | 문장·문단·줄바꿈·목록·표·마크다운·확신의 정도 보존 | 지침·기대 출력 대조 완료, 모델이 원칙을 항상 지키는지는 미검증 |
| 필요한 부분만 수정 | 자연스러운 표현·전문용어·의도적인 비유 보호 | 원칙 반영, 실제 과잉 교정률 미측정 |
| 두 방식에서 같은 원칙 사용 | 공통 지침과 조건부 규칙 16개 대조 | 파일 수준 대조 완료, 모델 간 동일 출력은 보장하지 않음 |
| 다른 컴퓨터에서도 등록 | 두 파일을 복사하는 Windows·Bash 설치기 제공 | Windows PowerShell 5.1·WSL Ubuntu 22.04의 임시 경로에서 설치 동작 확인 |

macOS와 Red Hat 계열에서는 설치기를 직접 실행해 확인하지 않았습니다. 실제 모델로 문장을 교정해 결과를 평가하는 시험은 하지 않았으며, AI 판별 점수나 개선율을 성과로 제시하지 않습니다. [검토 기준과 확인 내역](docs/design-and-validation.md)

### 교정 범위

- 이 스킬은 **이미 있는 한국어 글의 교정 전용**입니다. 새 글 작성이나 구성 재설계는 포함하지 않습니다.
- `핵심을 찔렀어` 같은 칭찬과 원문에 있는 제안·결말을 통째로 삭제하지 않습니다.
- 정확한 전문용어·비유와 코드·URL·직접 인용은 보존합니다. 보호 영역의 교정은 별도 요청 범위에만 적용합니다.
- 원문에 없는 원인·성과·행동을 만들어 “구체적인 글”로 바꾸지 않습니다.
- 단어만 보고 AI 작성 여부를 판별하거나 AI 흔적이 완전히 사라진다고 보장하지 않습니다.

## 기존 사용자는 어떻게 업데이트하나요?

스킬 이름은 계속 **`natural-korean`**입니다. 초기 버전에서 허용했던 새 글 작성·문장 합치기·구성 조절은 현재 교정 범위에서 제외했습니다. 이제 `references/rules.json`도 필요합니다.

처음 내려받은 저장소 폴더에서 최신 파일을 받고 설치기를 다시 실행합니다.

```bash
# macOS / WSL / Linux
git pull --ff-only
bash install.sh
```

```powershell
# Windows
git pull --ff-only
powershell -NoProfile -ExecutionPolicy Bypass -File .\install.ps1
```

GitHub에 새 파일이 올라와도 개인 컴퓨터의 설치본이 자동으로 바뀌지는 않습니다. 한 도구만 갱신하려면 처음 설치할 때와 같은 `--agent` 또는 `-Agent` 옵션을 붙이세요.

## 더 살펴보기

| 자료 | 내용 |
| --- | --- |
| [원샷 프롬프트](one-shot-prompt.txt) | 외부 파일 없이 붙여 넣는 전체 지침 |
| [스킬 원본](skills/natural-korean/SKILL.md) | 목적·보존 원칙·작업 순서·출력 조건 |
| [교정 규칙 JSON](skills/natural-korean/references/rules.json) | 의미 구별 6개, 조건부 규칙 16개, 표현 후보와 조사 한계 |
| [등록 안내](docs/installation.md) | OS별 등록·수동 복사·업데이트·복구 |
| [표현별 교정표 191행](docs/expression-change-table.md) | 수정 조건·교정 예시·유지 조건 |
| [검색 가능한 HTML 표](docs/expression-change-table.html) | 파일을 내려받아 브라우저에서 열면 검색·필터 사용 가능 |
| [검수용 사례 6개](docs/design-review-cases.md) | 수정 2개·유지 2개·근거 부족으로 유지 2개 |
| [설계와 검증 기록](docs/design-and-validation.md) | 제작 절차·검증 범위·기여 방법 |

HTML 파일은 GitHub에서 웹페이지로 실행되지 않습니다. 저장소를 내려받은 뒤 `docs/expression-change-table.html`을 브라우저로 여세요.

```text
oh-my-korean/
|-- README.md
|-- one-shot-prompt.txt
|-- install.sh
|-- install.ps1
|-- skills/
|   `-- natural-korean/
|       |-- SKILL.md
|       `-- references/
|           `-- rules.json
`-- docs/
    |-- installation.md
    |-- design-and-validation.md
    |-- design-review-cases.md
    |-- expression-change-table.md
    `-- expression-change-table.html
```
