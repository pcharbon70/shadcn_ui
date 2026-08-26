// Test-only removal; the production stylesheet is never rewritten on disk.
export async function removeFeatureGate(page, feature) {
  return page.evaluate(feature => {
    let removed = 0;
    function visit(parent) {
      for (let i = parent.cssRules.length - 1; i >= 0; i--) {
        const rule = parent.cssRules[i];
        if (rule instanceof CSSSupportsRule && rule.conditionText.includes(feature)) {
          parent.deleteRule(i); removed++;
        } else if (rule.cssRules) visit(rule);
      }
    }
    for (const sheet of document.styleSheets) visit(sheet);
    return removed;
  }, feature);
}
