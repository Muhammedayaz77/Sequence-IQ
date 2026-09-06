const PUZZLES = {
  Easy: [
    [2, 4, 6, 8, null, 12, [10, 14, 16, 11]],
    [3, 6, 9, 12, null, 18, [15, 21, 14, 16]],
    [5, 10, 15, 20, null, 30, [25, 35, 24, 28]],
    [1, 3, 5, 7, null, 11, [9, 13, 8, 10]],
    [10, 20, 30, null, 50, 60, [35, 40, 45, 55]],
    [2, 5, 8, 11, null, 17, [13, 14, 15, 16]],
    [20, 18, 16, null, 12, 10, [13, 14, 15, 11]],
    [4, 8, 12, 16, null, 24, [18, 19, 20, 22]],
    [7, 14, 21, null, 35, 42, [27, 28, 29, 30]],
    [100, 90, 80, null, 60, 50, [65, 70, 75, 55]],
    [1, 4, 7, 10, null, 16, [11, 12, 13, 14]],
    [6, 12, 18, null, 30, 36, [22, 24, 25, 26]],
    [50, 45, 40, null, 30, 25, [32, 33, 34, 35]],
    [2, 6, 10, 14, null, 22, [16, 17, 18, 20]],
    [9, 18, 27, null, 45, 54, [36, 37, 38, 39]],
    [1, 2, 4, 8, null, 32, [12, 14, 16, 18]],
    [30, 27, 24, null, 18, 15, [19, 20, 21, 22]],
    [11, 22, 33, null, 55, 66, [40, 41, 42, 44]],
    [8, 16, 24, 32, null, 48, [38, 40, 42, 44]],
    [3, 9, 15, null, 27, 33, [19, 20, 21, 22]]
  ],
  Hard: Array.from({length: 20}, (_, i) => [i + 2, (i + 2) * 2, (i + 2) * 3, null, (i + 2) * 5, (i + 2) * 6, [(i + 2) * 4, (i + 2) * 7, (i + 2) * 8, (i + 2) * 9]]),
  Master: Array.from({length: 20}, (_, i) => [i + 2, (i + 2) ** 2, (i + 2) ** 2 + i + 2, null, (i + 2) ** 2 + 3 * (i + 2), (i + 2) ** 2 + 4 * (i + 2), [(i + 2) ** 2 + 2 * (i + 2), (i + 2) ** 2 + 5 * (i + 2), (i + 2) ** 2 + 6 * (i + 2), (i + 2) ** 2 + 7 * (i + 2)]])
};

const state = {
  difficulty: 'Easy', level: 1, lives: 3, hints: Number(localStorage.getItem('sequenceIQ.hints') || 3),
  completed: JSON.parse(localStorage.getItem('sequenceIQ.completed') || '{}'), hintStage: 0,
  music: localStorage.getItem('sequenceIQ.music') !== 'false', sound: localStorage.getItem('sequenceIQ.sound') !== 'false'
};

const $ = id => document.getElementById(id);
const key = () => `${state.difficulty}-${state.level}`;
function save() { localStorage.setItem('sequenceIQ.completed', JSON.stringify(state.completed)); localStorage.setItem('sequenceIQ.hints', state.hints); localStorage.setItem('sequenceIQ.music', state.music); localStorage.setItem('sequenceIQ.sound', state.sound); }
function show(screen) { document.querySelectorAll('.screen').forEach(s => s.classList.remove('active')); $(screen).classList.add('active'); }
function unlocked(difficulty) { if (difficulty === 'Easy') return true; if (difficulty === 'Hard') return Object.keys(state.completed).filter(k => k.startsWith('Easy-')).length >= 20; return Object.keys(state.completed).filter(k => k.startsWith('Hard-')).length >= 20; }

function renderTabs() {
  const tab = document.querySelector('.tab.active')?.dataset.tab || 'play';
  const content = $('tabContent');
  if (tab === 'play') content.innerHTML = '<strong>Play</strong><p>Continue your number-series journey or choose a level. Easy is available now; complete all 20 Easy levels to unlock Hard.</p>';
  if (tab === 'shop') content.innerHTML = `<strong>Shop</strong><p>Daily free hint: ${navigator.onLine ? 'available online once per day.' : 'Connect to the internet to collect today’s free hint.'}</p><button id="dailyHint" class="secondary-button">Collect Daily Hint</button>`;
  if (tab === 'coming') content.innerHTML = '<strong>Coming Soon</strong><p>Future Sequence IQ content and features will appear here.</p>';
  if ($('dailyHint')) $('dailyHint').onclick = collectDailyHint;
}
function collectDailyHint() {
  if (!navigator.onLine) return alert('An internet connection is required to collect the daily hint.');
  const today = new Date().toISOString().slice(0, 10);
  if (localStorage.getItem('sequenceIQ.dailyHint') === today) return alert('Today’s free hint has already been collected.');
  localStorage.setItem('sequenceIQ.dailyHint', today); state.hints++; save(); alert('Daily hint collected.'); renderTabs();
}
function renderLevels() {
  const root = $('difficultyGroups'); root.innerHTML = '';
  ['Easy', 'Hard', 'Master'].forEach(difficulty => {
    const isUnlocked = unlocked(difficulty), completedCount = Object.keys(state.completed).filter(k => k.startsWith(`${difficulty}-`)).length;
    const section = document.createElement('section'); section.className = 'difficulty';
    section.innerHTML = `<div class="difficulty-header"><h3>${difficulty}</h3><span>${isUnlocked ? `${completedCount}/20 completed` : 'Locked'}</span></div><div class="level-grid"></div>`;
    const grid = section.querySelector('.level-grid');
    for (let i = 1; i <= 20; i++) {
      const button = document.createElement('button'); button.className = 'level'; button.textContent = i;
      if (state.completed[`${difficulty}-${i}`]) button.classList.add('completed');
      if (!isUnlocked) { button.classList.add('locked'); button.disabled = true; }
      else button.onclick = () => startLevel(difficulty, i);
      grid.appendChild(button);
    }
    root.appendChild(section);
  });
}
function startLevel(difficulty, level) { state.difficulty = difficulty; state.level = level; state.lives = 3; state.hintStage = 0; show('gameScreen'); renderPuzzle(); }
function renderPuzzle() {
  const p = PUZZLES[state.difficulty][state.level - 1];
  $('levelLabel').textContent = `${state.difficulty} · Level ${state.level}`; $('puzzleNumber').textContent = `PUZZLE ${String(state.level).padStart(2, '0')}`;
  $('livesLabel').textContent = '♥'.repeat(state.lives) + '♡'.repeat(3 - state.lives); $('progressBar').style.width = `${(state.level / 20) * 100}%`;
  $('hintBalance').textContent = `Hints: ${state.hints}`;
  $('sequence').innerHTML = p.slice(0, 6).map(n => `<span class="${n === null ? 'missing' : ''}">${n ?? '?'}</span>`).join('');
  const options = [p[0] === null ? null : p[6][0], ...p[6]].filter(Boolean).slice(0, 4);
  const correct = p.find((v, idx) => idx === 6) ? p[0] : null;
  const answer = p[5] === null ? p[4] : p.slice(0, 6).find((v, idx) => v === null);
  // V1 content records the missing value at index 4 for the Easy set.
  const correctAnswer = p[4] ?? p[3];
  const choices = [...new Set([correctAnswer, ...p[6]])].slice(0, 4);
  while (choices.length < 4) choices.push(correctAnswer + choices.length + 3);
  $('options').innerHTML = choices.map((n, i) => `<button class="option" data-value="${n}">${n}</button>`).join('');
  document.querySelectorAll('.option').forEach(btn => btn.onclick = () => choose(Number(btn.dataset.value), correctAnswer, btn));
  $('hintButton').disabled = state.hints <= 0 || state.hintStage >= 3; $('feedback').textContent = '';
}
function choose(value, answer, button) {
  if (value === answer) { button.classList.add('correct'); state.completed[key()] = true; save(); setTimeout(() => showComplete(), 350); }
  else { button.classList.add('wrong'); button.disabled = true; state.lives--; $('livesLabel').textContent = '♥'.repeat(state.lives) + '♡'.repeat(3 - state.lives); $('feedback').textContent = 'Not quite. Try another option.'; if (state.lives <= 0) setTimeout(() => show('gameOverScreen'), 350); }
}
function useHint() {
  if (state.hints <= 0 || state.hintStage >= 3) return;
  state.hints--; state.hintStage++; save();
  const buttons = [...document.querySelectorAll('.option:not(.wrong):not(.correct)')];
  if (state.hintStage === 1) buttons.slice(0, 2).forEach(b => b.classList.add('removed'));
  if (state.hintStage === 2) buttons.filter(b => !b.classList.contains('removed')).slice(0, 1).forEach(b => b.classList.add('removed'));
  if (state.hintStage === 3) { $('feedback').textContent = `The final answer is revealed: ${PUZZLES[state.difficulty][state.level - 1][4] ?? PUZZLES[state.difficulty][state.level - 1][3]}`; document.querySelectorAll('.option').forEach(b => { if (!b.classList.contains('removed')) b.classList.add('correct'); }); }
  $('hintBalance').textContent = `Hints: ${state.hints}`; $('hintButton').disabled = state.hints <= 0 || state.hintStage >= 3;
}
function showComplete() { $('completeText').textContent = state.level === 20 ? `${state.difficulty} complete. Great job!` : `You solved ${state.difficulty} Level ${state.level}.`; $('nextLevelButton').style.display = state.level < 20 ? 'block' : 'none'; show('completeScreen'); }

document.querySelectorAll('.tab').forEach(tab => tab.onclick = () => { document.querySelectorAll('.tab').forEach(t => t.classList.remove('active')); tab.classList.add('active'); renderTabs(); });
$('openPlayButton').onclick = () => { show('levelsScreen'); renderLevels(); };
$('backHomeButton').onclick = () => show('homeScreen');
$('backLevelsButton').onclick = () => { show('levelsScreen'); renderLevels(); };
$('retryButton').onclick = () => startLevel(state.difficulty, state.level);
$('resultLevelsButton').onclick = () => { show('levelsScreen'); renderLevels(); };
$('resultHomeButton').onclick = () => show('homeScreen');
$('completeLevelsButton').onclick = () => { show('levelsScreen'); renderLevels(); };
$('nextLevelButton').onclick = () => startLevel(state.difficulty, state.level + 1);
$('hintButton').onclick = useHint;
$('settingsButton').onclick = () => { $('settingsModal').classList.remove('hidden'); $('musicToggle').checked = state.music; $('soundToggle').checked = state.sound; };
$('closeSettingsButton').onclick = () => $('settingsModal').classList.add('hidden');
$('musicToggle').onchange = e => { state.music = e.target.checked; save(); };
$('soundToggle').onchange = e => { state.sound = e.target.checked; save(); };
window.addEventListener('online', renderTabs); window.addEventListener('offline', renderTabs);
renderTabs();
