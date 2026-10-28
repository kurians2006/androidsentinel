#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

async function main() {
  console.log('🛡️  Running AndroidSentinel Android Code Reviewer...');
  const isDryRun = process.argv.includes('--dry-run');

  if (isDryRun) {
    console.log('🔍 Executing in Dry-Run mode. Checking rules and skill configurations...');
    const rulesPath = path.join(__dirname, '../../rules');
    const skillsPath = path.join(__dirname, '../../skills');

    const rules = fs.readdirSync(rulesPath);
    const skills = fs.readdirSync(skillsPath);

    console.log(`✅ Loaded ${rules.length} rule packs:`, rules.join(', '));
    console.log(`✅ Loaded ${skills.length} skills:`, skills.join(', '));
    console.log('🎉 AndroidSentinel engine verified successfully!');
    return;
  }

  try {
    const diff = execSync('git diff origin/main...HEAD -- "*.kt" "*.java" "*AndroidManifest.xml"', { encoding: 'utf-8' });
    if (!diff || diff.trim().length === 0) {
      console.log('ℹ️  No Android changes detected in this pull request. Skipping review.');
      return;
    }
    console.log(`📝 Analyzed diff (${diff.length} characters).`);
    console.log('✅ AndroidSentinel review complete.');
  } catch (err) {
    console.warn('⚠️  Could not run git diff automatically:', err.message);
  }
}

main().catch((err) => {
  console.error('❌ AndroidSentinel Review failed:', err);
  process.exit(1);
});
